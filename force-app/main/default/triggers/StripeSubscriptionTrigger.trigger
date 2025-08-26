trigger StripeSubscriptionTrigger on Stripe_Subscription__c (after insert, after update) {
      if (TriggerBypass.bypassStripeSubscription) {
        return; // skip execution entirely
    }
      new StripeSubscriptionTriggerHandler().run();
}