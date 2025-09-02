@IsTest
public with sharing class StripeTestDataFactory {
  public static Stripe_Customer__c createStripeCustomer(Boolean doInsert) {
    Stripe_Customer__c customer = new Stripe_Customer__c(
      Customer_Email__c = 'test@example.com'
    );
    if (doInsert) {
      insert customer;
    }
    return customer;
  }

  public static Stripe_Subscription__c createStripeSubscription(
    Boolean doInsert,
    Id StripeCustomerId
  ) {
    Stripe_Subscription__c subscription = new Stripe_Subscription__c(
      Stripe_Customer__c = StripeCustomerId
    );
    if (doInsert) {
      insert subscription;
    }
    return subscription;
  }
}
