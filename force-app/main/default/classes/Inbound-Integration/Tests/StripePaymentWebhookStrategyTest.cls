@isTest
private class StripePaymentWebhookStrategyTest {
  @isTest
  static void testInvoicePaidHappyPath() {
    Stripe_Customer__c customer = StripeTestDataFactory.createStripeCustomer(
      true
    );
    Stripe_Subscription__c subscription = StripeTestDataFactory.createStripeSubscription(
      true,
      customer.Id
    );

    String body = StripeWebhookTestFixtures.paymentEvents(
      2000,
      customer.Id,
      subscription.Id,
      'invoice.paid'
    );

    Test.startTest();
    Integer result = new StripePaymentWebhookStrategy().handle(body);
    Test.stopTest();

    System.assertEquals(201, result, 'Should insert successfully');
    System.assertEquals(1, [SELECT COUNT() FROM Payment_Transaction__c]);
  }

  @isTest
  static void testInvoicePaidMissingSubscription() {
    Stripe_Customer__c customer = StripeTestDataFactory.createStripeCustomer(
      true
    );
    String body = StripeWebhookTestFixtures.paymentEvents(
      2000,
      customer.Id,
      null,
      'invoice.paid'
    );

    Test.startTest();
    Integer result = new StripePaymentWebhookStrategy().handle(body);
    Test.stopTest();

    System.assertEquals(
      400,
      result,
      'Should return 422 when no subscription found'
    );
  }
}
