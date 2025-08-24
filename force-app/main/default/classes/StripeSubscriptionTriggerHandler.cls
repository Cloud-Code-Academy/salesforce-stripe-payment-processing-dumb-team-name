public with sharing class StripeSubscriptionTriggerHandler extends TriggerHandler {

    private Map<Id, Stripe_Subscription__c> newSubscriptionMap;
    private Map<Id, Stripe_Subscription__c> oldSubscriptionMap;
    
    public StripeSubscriptionTriggerHandler() {
        this.newSubscriptionMap = (Map<Id, Stripe_Subscription__c>) Trigger.newMap;
        this.oldSubscriptionMap = (Map<Id, Stripe_Subscription__c>) Trigger.oldMap;
        this.setMaxLoopCount(1);
    }
    
    public override void afterInsert(){
            StripeSubscriptionService.handleNewSubscriptions(newSubscriptionMap);
    }

    public override void afterUpdate() {
        System.debug('afterUpdate called, newSubscriptionMap: ' + newSubscriptionMap.keySet());
            StripeSubscriptionService.handleUpdatedSubscriptions(newSubscriptionMap, oldSubscriptionMap);
        
    }
}