trigger StripeCustomerTrigger on Stripe_Customer__c (after update) {
    new StripeCustomerTriggerHandler().run();
}