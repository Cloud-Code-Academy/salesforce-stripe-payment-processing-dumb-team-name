public with sharing class StripePaymentWebhookStrategy implements IStripeWebhookStrategy{
    public static void handle(String requestBody){
        Logger.info('Hello from Payment Strategy!');
   }
}