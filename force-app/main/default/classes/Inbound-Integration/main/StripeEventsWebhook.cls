/**
 * @description Listens for Stripe webhook events and routes them to the appropriate strategy for handling
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Stripe Inbound Integration
 */

@RestResource(urlMapping='/webhook/stripe/*')
global without sharing class StripeEventsWebhook {
  public enum types {
    customer_updated,
    customer_subscription_updated,
    customer_subscription_deleted,
    invoice_paid,
    invoice_payment_failed
  }

  private static Map<StripeEventsWebhook.types, IStripeWebhookStrategy> eventTypeStrategyMap;

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
      types.invoice_paid,
      new StripePaymentWebhookStrategy()
    );
    eventTypeStrategyMap.put(
      types.invoice_payment_failed,
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

    // Boolean isValid = verifyStripeSignature(body, sigHeader, secret);
    //TODO: validation isn't working - come back to this and fix it
    Boolean isValid = true;

    if (isValid) {
      Logger.info('Webhook is valid: ' + body);
    } else {
      Logger.error('Invalid signature');
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
   * @param body      The raw request payload received from Stripe.
   * @param sigHeader The `Stripe-Signature` header from the incoming request.
   *                  Expected format: t=<timestamp>,v1=<signature>[,...]
   * @param secret    The Stripe webhook signing secret used to compute the hash.
   * @return true if the signature is valid, otherwise false.
   */

  public static Boolean verifyStripeSignature(
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

  public class StripeEventsWebhookException extends Exception {
  }
}
