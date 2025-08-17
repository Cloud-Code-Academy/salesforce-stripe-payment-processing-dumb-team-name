trigger StripeSubscriptionTrigger on Stripe_Subscription__c (after insert) {
      new StripeSubscriptionTriggerHandler().run();
}