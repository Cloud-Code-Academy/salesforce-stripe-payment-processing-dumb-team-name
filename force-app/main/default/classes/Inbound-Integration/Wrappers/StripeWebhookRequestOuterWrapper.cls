/**
 * @description Wrapper class used for getting the event type
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Stripe Inbound Integration
 */
public with sharing class StripeWebhookRequestOuterWrapper {
  public String type { get; }

  public static String getEventType(String requestBody) {
    StripeWebhookRequestOuterWrapper outerWrapper = (StripeWebhookRequestOuterWrapper) JSON.deserialize(
      requestBody,
      StripeWebhookRequestOuterWrapper.class
    );

    Logger.info('Request type is: ' + outerWrapper.type);
    return outerWrapper.type.toString();
  }

  /**
   * @description Converts period to underscore so that customer.updated becomes customer_updated (for example). This is required for enum values.
   *
   * @return String The converted string. (e.g. customer_updated)
   */
  public static String normaliseEventType(String oldEventType) {
    //TODO: Add a guard clause
    String newEventType = OldEventType.replaceAll('\\.', '_');

    return newEventType;
  }
}
