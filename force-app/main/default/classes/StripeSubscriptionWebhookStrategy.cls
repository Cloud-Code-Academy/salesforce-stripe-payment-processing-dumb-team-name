public with sharing class StripeSubscriptionWebhookStrategy implements IStripeWebhookStrategy {
  public Integer handle(String requestBody) {
    Logger.info('Executing subscription strategy.');

    //Determine if the subscription was updated, deleted, paused, or resumed?

    StripeWebhookRequestOuterWrapper outerWrapper = (StripeWebhookRequestOuterWrapper) JSON.deserialize(
      requestBody,
      StripeWebhookRequestOuterWrapper.class
    );

    StripeWebhookSubscriptionWrapper wrapper = StripeWebhookSubscriptionWrapper.parseWebhookBody(
      requestBody
    );
    System.debug('What the wrapper looks like: ' + wrapper);

    Logger.info('Event Type: ' + wrapper.type);
    Logger.info('Subscription ID: ' + wrapper.data.object_x.id);
    Logger.info('Status: ' + wrapper.data.object_x.status);
    Logger.info('Price ID: ' + wrapper.data.object_x.items.data[0].price.id);
    Logger.info('Quantity: ' + wrapper.data.object_x.items.data[0].quantity);
    Logger.saveLog();
    return 201;
  }

  public void handleUpdate() {
  }
}
