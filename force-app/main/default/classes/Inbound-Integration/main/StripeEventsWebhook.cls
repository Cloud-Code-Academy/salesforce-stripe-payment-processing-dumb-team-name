/**
 * @description Listens for Stripe webhook events and routes them to the appropriate strategy for handling
 *
 * @author Jonathan Lyles
 * @date August 30, 2025
 * @group Stripe Inbound Integration
 */

@RestResource(urlMapping='/webhook/*')
//@RestResource(urlMapping='/webhook/stripe/*')
global without sharing class StripeEventsWebhook {
  public enum types {
    customer_updated,
    customer_subscription_created,
    customer_subscription_updated,
    customer_subscription_deleted,
    invoice_paid
  }

  private static Map<StripeEventsWebhook.types, IStripeWebhookStrategy> eventTypeStrategyMap;

  static {
    eventTypeStrategyMap = new Map<StripeEventsWebhook.types, IStripeWebhookStrategy>();
    eventTypeStrategyMap.put(
      types.customer_updated,
      new StripeCustomerWebhookStrategy()
    );
    eventTypeStrategyMap.put(
      types.customer_subscription_created,
      new StripeSubscriptionWebhookStrategy()
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
      types.invoice_paid,
      new StripePaymentWebhookStrategy()
    );
  }

  /**
   * Handles Stripe webhook events sent via Http Post. Determines the event type and calls the appropriate strategy.
   *
   * @return Integer - Http response codes.
   */

  @HttpPost
  global static Integer handleWebhookPost() {
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;

    String body = request.requestBody.toString();

    // object and currency are reserved keywords
    body = body.replaceAll('object', 'object_x');
    body = body.replaceAll('currency', 'currency_x');

    String sigHeader = request.headers.get('Stripe-Signature');

    String secret = getStripeWebhookSecret();

    // Send the raw request body as String, not the request body where the reserved keywords were changed.
    Boolean isValid = verifyStripeSignature(
      request.requestBody.toString(),
      sigHeader,
      secret
    );

    if (isValid) {
      Logger.info('Webhook is valid: ' + body);
    } else {
      Logger.error('Invalid signature');
      Logger.saveLog();
      return response.statusCode = 401;
    }

    String eventType = StripeWebhookRequestOuterWrapper.getEventType(body);

    // Converts "customer.created" -> "customer_created"
    String strategyKey = StripeWebhookRequestOuterWrapper.normaliseEventType(
      eventType
    );

    StripeEventsWebhook.types enumValue;

    try {
      enumValue = StripeEventsWebhook.types.valueOf(strategyKey);
    } catch (Exception e) {
      return response.statusCode = 404;
    }

    IStripeWebhookStrategy strategyObject = eventTypeStrategyMap.get(enumValue);

    try {
      if (strategyObject == null) {
        throw new StripeEventsWebhookException(
          'Error: no strategy found for: ' + enumValue
        );
      }
    } catch (Exception e) {
      Logger.error(e.getMessage());
      return response.statusCode = 404;
    }

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
   * @description Retrieves the webhook secret from custom metadata for signature verification
   *
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
   * @param Blob requestBody  The raw request payload received from Stripe.
   * @param String sigHeader  The `Stripe-Signature` header from the incoming request. Expected format: t=<timestamp>,v1=<signature>[,...]
   * @param String secret     The Stripe webhook signing secret used to compute the hash.
   * @return Boolean          True if the signature is valid, otherwise false.
   */

  public static Boolean verifyStripeSignature(
    String requestBodyAsString,
    String sigHeader,
    String secret
  ) {
    if (sigHeader == null) {
      return false;
    }

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
    String signedPayload = timestamp + '.' + requestBodyAsString;

    // Compute HMAC-SHA256
    Blob key = Blob.valueOf(secret);
    Blob message = Blob.valueOf(signedPayload);
    Blob hash = Crypto.generateMac('HMACSHA256', message, key);
    String hashHex = EncodingUtil.convertToHex(hash);

    // Compare
    return hashHex.equalsIgnoreCase(expectedSig);
  }

  public static String handleReservedKeywords(String textBody) {
    // object and currency are reserved keywords
    textBody = textBody.replaceAll('object', 'object_x');
    textBody = textBody.replaceAll('currency', 'currency_x');
    return textBody;
  }

  public class StripeEventsWebhookException extends Exception {
  }
}
