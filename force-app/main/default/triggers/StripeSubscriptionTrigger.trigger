trigger StripeSubscriptionTrigger on Stripe_Subscription__c (after insert, after update) {
      new StripeSubscriptionTriggerHandler().run();
}