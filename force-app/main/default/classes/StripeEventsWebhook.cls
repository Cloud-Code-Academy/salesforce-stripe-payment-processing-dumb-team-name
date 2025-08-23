/**
 * @description Listens and handle certain Stripe events
 * @author Jonathan Lyles
 * @description August 17, 2025
 */

@RestResource(urlMapping='/webhook/stripe/*')
global without sharing class StripeEventsWebhook {
  // The list of events being tracked
  public enum types {
    customer_updated,
    customer_subscription_updated,
    customer_subscription_deleted,
    customer_subscription_paused,
    customer_subscription_resumed,
    invoice_paid,
    invoice_payment_failed
  }

  // Maps each event to its respective strategy
  private static Map<StripeEventsWebhook.types, IStripeWebhookStrategy> eventTypeStrategyMap;

  // Sets key/value pairs in eventTypeStrategyMap
  static {
    eventTypeStrategyMap = new Map<StripeEventsWebhook.types, IStripeWebhookStrategy>();
    eventTypeStrategyMap.put(
      types.customer_updated,
      new StripeCustomerWebhookStrategy()
    );
    eventTypeStrategyMap.put(
      types.customer_subscription_updated,
      new StripeSubscriptionWebhookStrategy()
    );
    eventTypeStrategyMap.put(
      types.customer_subscription_deleted,
      new StripeSubscriptionWebhookStrategy()
    );
    eventTypeStrategyMap.put(
      types.customer_subscription_paused,
      new StripeSubscriptionWebhookStrategy()
    );
    eventTypeStrategyMap.put(
      types.customer_subscription_resumed,
      new StripeSubscriptionWebhookStrategy()
    );
    eventTypeStrategyMap.put(
      types.invoice_paid,
      new StripePaymentWebhookStrategy()
    );
    eventTypeStrategyMap.put(
      types.invoice_payment_failed,
      new StripePaymentWebhookStrategy()
    );
  }

  /**
   * @description Handles events by Stripe's webhook sent via Http Post. Determines the event type and calls the appropriate strategy.
   */

  @HttpPost
  global static Integer handleWebhookPost() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    // Step 1: Get the body
    String body = request.requestBody.toString();

    // Step 2: Get signature from headers
    String sigHeader = request.headers.get('Stripe-Signature');

    // Step 3: Verify signature
    String secret = getStripeWebhookSecret();

    Boolean isValid = verifyStripeSignature(body, sigHeader, secret);

    if (isValid) {
      // Process payload
      Logger.info('Webhook is valid: ' + body);
    } else {
      Logger.error('Invalid signature');
      return response.statusCode = 401;
    }

    StripeWebhookRequestOuterWrapper outerWrapper = (StripeWebhookRequestOuterWrapper) JSON.deserialize(
      request.requestBody.toString(),
      StripeWebhookRequestOuterWrapper.class
    );

    Logger.info('Request type is: ' + outerWrapper.type);
    Logger.info('Stripe Webhook Request: ' + JSON.serialize(request));

    // Convert "customer.created" -> "customer_created"
    String strategyKey = outerWrapper.type.replaceAll('\\.', '_');

    // Use Apex’s built-in method to get the enum value dynamically

    StripeEventsWebhook.types enumValue;

    try {
      enumValue = StripeEventsWebhook.types.valueOf(strategyKey);
    } catch (Exception e) {
      return response.statusCode = 404;
    }

    // Dynamically select the strategy

    IStripeWebhookStrategy strategyObject = eventTypeStrategyMap.get(enumValue);

    StripeWebhookQueueable stripeWebhookQueueable = new StripeWebhookQueueable(
      strategyObject,
      body
    );

    System.enqueueJob(stripeWebhookQueueable);

    response.statusCode = 201;
    Logger.saveLog();
    return response.statusCode;
  }

  /**
   * @description Retrieves the webhook secret for verification
   * @return String (the secret)
   */
  global static String getStripeWebhookSecret() {
    String secret;

    if (Test.isRunningTest()) {
      secret = 'whsec_test123';
    } else {
      Stripe_Webhook_Setting__mdt stripeWebhookSettings = [
        SELECT Webhook_Secret__c
        FROM Stripe_Webhook_Setting__mdt
        WHERE Is_Active__c = TRUE
        LIMIT 1
      ];

      secret = stripeWebhookSettings.Webhook_Secret__c;
    }

    return secret;
  }

  /**
   * @description Verifies the Stripe webhook signature using HMAC-SHA256.
   *
   * @param body      The raw request payload received from Stripe.
   * @param sigHeader The `Stripe-Signature` header from the incoming request.
   *                  Expected format: t=<timestamp>,v1=<signature>[,...]
   * @param secret    The Stripe webhook signing secret used to compute the hash.
   * @return true if the signature is valid, otherwise false.
   */

  global static Boolean verifyStripeSignature(
    String body,
    String sigHeader,
    String secret
  ) {
    if (sigHeader == null) {
      return false;
    }

    // Parse header (t=timestamp,v1=signature,...)
    Map<String, String> sigMap = new Map<String, String>();

    for (String part : sigHeader.split(',')) {
      List<String> kv = part.split('=');

      if (kv.size() == 2) {
        sigMap.put(kv[0], kv[1]);
      }
    }

    if (!sigMap.containsKey('t') || !sigMap.containsKey('v1')) {
      return false;
    }

    String timestamp = sigMap.get('t');
    String expectedSig = sigMap.get('v1');

    // Build signed payload string
    String signedPayload = timestamp + '.' + body;

    // Compute HMAC-SHA256
    Blob key = Blob.valueOf(secret);
    Blob message = Blob.valueOf(signedPayload);
    Blob hash = Crypto.generateMac('HMACSHA256', message, key);
    String hashHex = EncodingUtil.convertToHex(hash);

    // Compare
    return hashHex.equalsIgnoreCase(expectedSig);
  }
}
