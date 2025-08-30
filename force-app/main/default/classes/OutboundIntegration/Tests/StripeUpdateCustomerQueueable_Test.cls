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

@IsTest
private class StripeUpdateCustomerQueueable_Test {
  // --- Mock for success case ---
  private class StripeCustomerUpdateMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
      System.assertEquals('POST', req.getMethod(), 'Expected POST method');
      System.assert(
        req.getEndpoint().contains('/v1/customers/'),
        'Endpoint should include /customers/'
      );

      HttpResponse res = new HttpResponse();
      res.setStatusCode(200);
      res.setBody('{"id": "cus_test123", "object": "customer"}');
      return res;
    }
  }

  // --- Mock for error case ---
  private class StripeCustomerErrorMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
      HttpResponse res = new HttpResponse();
      res.setStatusCode(400);
      res.setBody('{"error": "Bad Request"}');
      return res;
    }
  }

  @IsTest
  static void testExecuteUpdatesCustomerSuccessfully() {
    // Arrange
    Stripe_Customer__c testCustomer = new Stripe_Customer__c(
      Customer_Name__c = 'Test User',
      Customer_Email__c = 'test@example.com',
      Customer_Phone__c = '1234567890',
      Stripe_Customer_ID__c = 'cus_12345'
    );
    insert testCustomer;

    Map<Id, Stripe_Customer__c> updateMap = new Map<Id, Stripe_Customer__c>{
      testCustomer.Id => testCustomer
    };

    Test.setMock(HttpCalloutMock.class, new StripeCustomerUpdateMock());

    // Act
    Test.startTest();
    System.enqueueJob(new StripeUpdateCustomerQueueable(updateMap));
    Test.stopTest();

    // Assert
    Stripe_Customer__c after = [
      SELECT Id, Stripe_Customer_ID__c
      FROM Stripe_Customer__c
      WHERE Id = :testCustomer.Id
    ];
    System.assertEquals(
      'cus_12345',
      after.Stripe_Customer_ID__c,
      'Customer Stripe ID should remain unchanged'
    );
  }

  @IsTest
  static void testExecuteHandlesHttpError() {
    // Arrange
    Stripe_Customer__c testCustomer = new Stripe_Customer__c(
      Customer_Name__c = 'Error User',
      Customer_Email__c = 'error@example.com',
      Stripe_Customer_ID__c = 'cus_error'
    );
    insert testCustomer;

    Map<Id, Stripe_Customer__c> updateMap = new Map<Id, Stripe_Customer__c>{
      testCustomer.Id => testCustomer
    };

    Test.setMock(HttpCalloutMock.class, new StripeCustomerErrorMock());

    // Act
    Test.startTest();
    System.enqueueJob(new StripeUpdateCustomerQueueable(updateMap));
    Test.stopTest();

    // Assert
    Stripe_Customer__c after = [
      SELECT Id
      FROM Stripe_Customer__c
      WHERE Id = :testCustomer.Id
    ];
    System.assertNotEquals(
      null,
      after,
      'Customer record should still exist even if callout fails'
    );
  }
}
