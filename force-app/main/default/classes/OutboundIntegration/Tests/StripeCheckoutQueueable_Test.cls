/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class StripeCheckoutQueueable_Test {
  private class StripeCheckoutMock implements HttpCalloutMock {
    private Integer statusCode;
    private String body;

    StripeCheckoutMock(Integer statusCode, String body) {
      this.statusCode = statusCode;
      this.body = body;
    }

    public HTTPResponse respond(HTTPRequest request) {
      HttpResponse res = new HttpResponse();
      res.setBody(body);
      res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
      res.setStatusCode(statusCode);
      return res;
    }
  }

  @testSetup
  static void setupData() {
    Stripe_Customer__c cust = new Stripe_Customer__c(
      Stripe_Customer_ID__c = 'cus_123',
      Customer_Email__c = 'test@example.com'
    );
    insert cust;

    Stripe_Subscription__c sub = new Stripe_Subscription__c(
      Stripe_Price_ID__c = 'price_123',
      Stripe_Customer__c = cust.Id
    );
    insert sub;
  }

  @isTest
  static void testSuccessfulCheckout() {
    // Arrange
    Stripe_Subscription__c sub = [
      SELECT Id
      FROM Stripe_Subscription__c
      LIMIT 1
    ];
    Map<Id, Stripe_Subscription__c> subsMap = new Map<Id, Stripe_Subscription__c>{
      sub.Id => sub
    };

    // Fake Stripe response
    String fakeResponse = '{"id":"cs_test_123","object":"checkout.session","url":"https://checkout.stripe.com/test","subscription":"sub_456"}';
    Test.setMock(
      HttpCalloutMock.class,
      new StripeCheckoutMock(200, fakeResponse)
    );

    Test.startTest();
    System.enqueueJob(new StripeCheckoutQueueable(subsMap));
    Test.stopTest();

    // Assert that subscription was updated
    Stripe_Subscription__c updatedSub = [
      SELECT
        Stripe_Subscription_ID__c,
        Stripe_Checkout_Session_Id__c,
        Checkout_URL__c,
        Sync_Status__c
      FROM Stripe_Subscription__c
      WHERE Id = :sub.Id
    ];

    System.assertEquals(
      'sub_456',
      updatedSub.Stripe_Subscription_ID__c,
      'Should set subscription id'
    );
    System.assertEquals(
      'cs_test_123',
      updatedSub.Stripe_Checkout_Session_Id__c,
      'Should set session id'
    );
    System.assertEquals(
      'https://checkout.stripe.com/test',
      updatedSub.Checkout_URL__c,
      'Should set URL'
    );
    System.assertEquals(
      'Checkout Created',
      updatedSub.Sync_Status__c,
      'Should update sync status'
    );
  }

  @isTest
  static void testFailedCheckout() {
    Stripe_Subscription__c sub = [
      SELECT Id
      FROM Stripe_Subscription__c
      LIMIT 1
    ];
    Map<Id, Stripe_Subscription__c> subsMap = new Map<Id, Stripe_Subscription__c>{
      sub.Id => sub
    };

    // Mock 400 error
    Test.setMock(
      HttpCalloutMock.class,
      new StripeCheckoutMock(400, '{"error":"Bad Request"}')
    );

    Test.startTest();
    System.enqueueJob(new StripeCheckoutQueueable(subsMap));
    Test.stopTest();

    Stripe_Subscription__c unchangedSub = [
      SELECT Sync_Status__c, Stripe_Checkout_Session_Id__c
      FROM Stripe_Subscription__c
      WHERE Id = :sub.Id
    ];

    System.assertEquals(
      null,
      unchangedSub.Stripe_Checkout_Session_Id__c,
      'Should not populate session id on failure'
    );
  }

  @isTest
  static void testMissingCustomerId() {
    Stripe_Customer__c cust2 = new Stripe_Customer__c(
      Customer_Email__c = 'jtowers@example.com'
    );
    insert cust2;

    Stripe_Subscription__c sub = new Stripe_Subscription__c(
      Stripe_Price_ID__c = 'price_missing',
      Stripe_Customer__c = cust2.Id
    );
    insert sub;

    Map<Id, Stripe_Subscription__c> subsMap = new Map<Id, Stripe_Subscription__c>{
      sub.Id => sub
    };

    // Mock response (shouldn’t be called, since customer id is blank)
    Test.setMock(
      HttpCalloutMock.class,
      new StripeCheckoutMock(200, '{"id":"should_not_hit"}')
    );

    Test.startTest();
    System.enqueueJob(new StripeCheckoutQueueable(subsMap));
    Test.stopTest();

    // Assert no updates happened
    Stripe_Subscription__c unchangedSub = [
      SELECT Stripe_Checkout_Session_Id__c
      FROM Stripe_Subscription__c
      WHERE Id = :sub.Id
    ];
    System.assertEquals(
      null,
      unchangedSub.Stripe_Checkout_Session_Id__c,
      'Should not update when customer ID is missing'
    );
  }
}
