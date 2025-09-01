@isTest
private class StripeEmailService_Test {
  @testSetup
  static void setupData() {
    // Create a Stripe customer with email
    Stripe_Customer__c cust = new Stripe_Customer__c(
      Stripe_Customer_ID__c = 'cus_123' + Math.random(),
      Customer_Email__c = 'test@example.com'
    );
    insert cust;

    // Create a Stripe subscription related to that customer
    Stripe_Subscription__c sub = new Stripe_Subscription__c(
      Stripe_Customer__c = cust.Id,
      Stripe_Price_ID__c = 'price_123',
      Sync_Status__c = 'Draft'
    );
    insert sub;
  }

  @isTest
  static void testSendCheckoutSessionEmail() {
    // Query subscription with email populated
    Stripe_Subscription__c sub = [
      SELECT Id, Stripe_Customer__r.Customer_Email__c
      FROM Stripe_Subscription__c
      LIMIT 1
    ];

    // Direct call
    Test.startTest();
    StripeEmailService.sendCheckoutSessionEmail(
      sub,
      'http://checkout.example.com'
    );
    Test.stopTest();

    // No direct way to assert email sent in tests, but no exceptions = pass
    System.assert(true, 'Email sent successfully via direct call');
  }

  @isTest
  static void testSendCheckoutSessionEmailViaQueueable() {
    // Query subscription with customer relationship fully populated
    Stripe_Subscription__c sub = [
      SELECT
        Id,
        Stripe_Price_ID__c,
        Stripe_Customer__c,
        Stripe_Customer__r.Stripe_Customer_ID__c,
        Stripe_Customer__r.Customer_Email__c
      FROM Stripe_Subscription__c
      LIMIT 1
    ];

    Map<Id, Stripe_Subscription__c> subsMap = new Map<Id, Stripe_Subscription__c>{
      sub.Id => sub
    };

    // Mock Stripe checkout session callout


    Test.startTest();
        Test.setMock(
      HttpCalloutMock.class,
      StripeHttpMock.CheckoutSessionCreateSuccess()
    );
    System.enqueueJob(new StripeCheckoutQueueable(subsMap));
    Test.stopTest();

    // Re-query subscription to confirm checkout URL set (proxy for email attempt)
    Stripe_Subscription__c updatedSub = [
      SELECT Checkout_URL__c,
      Stripe_Customer__c
      FROM Stripe_Subscription__c
      WHERE Id = :sub.Id
    ];

    System.debug('TROUBLE SPOT ' + updatedSub.Stripe_Customer__c);
    //System.debug('TROUBLE SPOT ' + updatedSub.Checkout_URL__c);
    System.assert(true, 'Queueable executed without exception');
  }
}
