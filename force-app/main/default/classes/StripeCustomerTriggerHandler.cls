public with sharing class StripeCustomerTriggerHandler {

    private Map<Id, Stripe_Customer__c> newStripeCustomerMap;
    
    public StripeCustomerTriggerHandler() {
        
        this.newStripeCustomerMap = (Map<Id, Stripe_Customer__c>) Trigger.newMap;
        this.setMaxLoopCount(1);

    }

    public override void afterInsert(){

        ContactService.StripeCustomerInsertToContactSync(newStripeCustomerMap);
        
    }
}