public with sharing class StripeService {
    public static Stripe_Customer__c newStripeCustomer(Id contactId, String name, String email){
        Stripe_Customer__c newStripeCust = new Stripe_Customer__c(
                    Contact__c = contactId,
                    Customer_Email__c = email,
                    Customer_Name__c = name, 
                    Stripe_Customer_ID__c = contactId);
        return newStripeCust;                     
    }

    public static void insertNewStripeCustomers(List<Stripe_Customer__c> stripeCustomersToInsert){
        insert stripeCustomersToInsert;
    }
}