public with sharing class StripeSubscriptionWebhookStrategy implements IStripeWebhookStrategy{
    public static void handle(String requestBody){
        Logger.info('Hello from Subscription Strategy!');
   }
}

 