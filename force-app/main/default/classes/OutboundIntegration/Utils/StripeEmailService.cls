public with sharing class StripeEmailService {
    public static void sendCheckoutSessionEmail (Stripe_Subscription__c sub, String checkoutURL) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {sub.Stripe_Customer__r.Customer_Email__c});
        mail.setSubject('Please Complete Your Hot Dog Subscription');
        mail.setPlainTextBody('Complete your payment at the URL: ' + checkoutURL);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}

