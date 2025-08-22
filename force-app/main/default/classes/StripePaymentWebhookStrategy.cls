public with sharing class StripePaymentWebhookStrategy implements IStripeWebhookStrategy {
    
    public static Integer handle(String requestBody){
    
        Logger.info('Hello from Payment Strategy!');
    
        return 201;
    }

}