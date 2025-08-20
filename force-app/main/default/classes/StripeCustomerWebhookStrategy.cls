public with sharing class StripeCustomerWebhookStrategy implements IStripeWebhookStrategy {

   public static void handle(String requestBody) {

      Logger.info('Hello from Customer Strategy!');
      Logger.info('This is the request body: ' + requestBody);

   }

}