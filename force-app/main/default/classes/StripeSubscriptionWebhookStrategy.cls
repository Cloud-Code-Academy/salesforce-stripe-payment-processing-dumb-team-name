public with sharing class StripeSubscriptionWebhookStrategy implements IStripeWebhookStrategy {
  public Integer handle(String requestBody) {
    Logger.info('Hello from Subscription Strategy!');

    return 201;
  }
}
