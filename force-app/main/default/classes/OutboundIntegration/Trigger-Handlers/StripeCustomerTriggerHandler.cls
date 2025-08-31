public with sharing class StripeCustomerTriggerHandler extends TriggerHandler {
  private Map<Id, Stripe_Customer__c> oldStripeCustomersMap;
  private Map<Id, Stripe_Customer__c> newStripeCustomersMap;

  public StripeCustomerTriggerHandler() {
    this.oldStripeCustomersMap = (Map<Id, Stripe_Customer__c>) Trigger.oldMap;
    this.newStripeCustomersMap = (Map<Id, Stripe_Customer__c>) Trigger.newMap;
    this.setMaxLoopCount(1);
  }

  public override void afterUpdate() {
    StripeCustomerService.handleUpdateStripeCustomers(
      oldStripeCustomersMap,
      newStripeCustomersMap
    );
  }
}
