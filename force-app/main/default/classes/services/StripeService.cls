/**
 * @description - Business logic and dml for custom Stripe objects
 * @author - Jonathan Lyles
 * @date - August 11, 2025
 */
public with sharing class StripeService {

    //TODO: does this need to be bulkified?
    /**
     * @description - Use to create a Stripe customer record in memory
     * @param - 
     */
    public static Stripe_Customer__c newStripeCustomer(Id contactId, StripeAPIResponseWrappers newStripeCustomer){
        Stripe_Customer__c stripeCustomer = new Stripe_Customer__c(
                    Contact__c = contactId,
                    Customer_Email__c = newStripeCustomer.email,
                    Customer_Name__c = newStripeCustomer.name, 
                    Stripe_Customer_ID__c = newStripeCustomer.Id);
        System.debug(stripeCustomer);
        return stripeCustomer;                     
    }

    public static List<Stripe_Customer__c> insertNewStripeCustomers(List<Stripe_Customer__c> stripeCustomersToInsert){
        insert stripeCustomersToInsert;
        System.debug(stripeCustomersToInsert);
        return stripeCustomersToInsert;
    }

    
}