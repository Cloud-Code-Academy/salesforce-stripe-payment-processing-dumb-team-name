public with sharing class StripeSubscriptionTriggerHandler extends TriggerHandler {

    private Map<Id, Stripe_Subscription__c> newSubscriptionMap;
    
    public StripeSubscriptionTriggerHandler() {
        this.newSubscriptionMap = (Map<Id, Stripe_Subscription__c>) Trigger.newMap;
        this.setMaxLoopCount(1);
    }
    
    public override void afterInsert(){
            StripeSubscriptionService.handleNewSubscriptions(newSubscriptionMap);
    }

    public override void afterUpdate() {
        
    }
}