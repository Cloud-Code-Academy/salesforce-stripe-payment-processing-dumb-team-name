public with sharing class StripeCustomerWebhookStrategy implements IStripeWebhookStrategy {
  public static Integer handle(String requestBody) {
    Logger.info('Hello from Customer Strategy!');
    Logger.info('This is the request body: ' + requestBody);

    return 201;
  }
}
