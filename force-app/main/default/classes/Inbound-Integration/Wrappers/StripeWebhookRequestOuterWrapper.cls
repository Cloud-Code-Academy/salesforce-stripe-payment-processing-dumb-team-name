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

  public static String normaliseEventType(String oldEventType) {
    //TODO: Add a guard clause
    String newEventType = OldEventType.replaceAll('\\.', '_');

    return newEventType;
  }
}
