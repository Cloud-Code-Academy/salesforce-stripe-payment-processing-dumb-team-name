trigger StripeCustomerTrigger on Stripe_Customer__c (after insert) {
    new StripeCustomerTriggerHandler().run();
}