@IsTest
private class StripeCustomerWebhookStrategyTest {
  //   @IsTest
  //   static void testUnsupportedEventType() {
  //     // Insert a dummy Stripe customer record
  //     Stripe_Customer__c cust = new Stripe_Customer__c(
  //       Stripe_Customer_ID__c = 'cus_TEST123'
  //     );
  //     insert cust;

  //     // Fake payload with unsupported type
  //     String body =
  //       '{' +
  //       '"id": "evt_test_001",' +
  //       '"type": "customer.created",' +
  //       '"data": {' +
  //       '  "object_x": {' +
  //       '    "id": "cus_TEST123",' +
  //       '    "email": "someone@example.com",' +
  //       '    "name": "Fake Name",' +
  //       '    "phone": "1234567890",' +
  //       '    "default_source": "pm_12345"' +
  //       '  }' +
  //       '}' +
  //       '}';

  //     Integer result = new StripeCustomerWebhookStrategy().handle(body);
  //     System.assertEquals(404, result, 'Unsupported type should return 404');
  //   }

  //   @IsTest
  //   static void testCustomerUpdatedSuccess() {
  //     // Insert a dummy Stripe customer record
  //     Stripe_Customer__c cust = new Stripe_Customer__c(
  //       Stripe_Customer_ID__c = 'cus_TEST456'
  //     );
  //     insert cust;

  //     // Payload with supported type: customer.updated
  //     String body =
  //       '{' +
  //       '"id": "evt_test_002",' +
  //       '"type": "customer.updated",' +
  //       '"data": {' +
  //       '  "object_x": {' +
  //       '    "id": "cus_TEST456",' +
  //       '    "email": "updated@example.com",' +
  //       '    "name": "Updated Name",' +
  //       '    "phone": "9999999999",' +
  //       '    "default_source": "pm_UPDATED"' +
  //       '  }' +
  //       '}' +
  //       '}';

  //     Integer result = new StripeCustomerWebhookStrategy().handle(body);
  //     System.assertEquals(204, result, 'Should update successfully');

  //     // Verify fields updated
  //     Stripe_Customer__c updatedCust = [
  //       SELECT
  //         Customer_Email__c,
  //         Customer_Name__c,
  //         Customer_Phone__c,
  //         Default_Payment_Method__c
  //       FROM Stripe_Customer__c
  //       WHERE Id = :cust.Id
  //     ];

  //     System.assertEquals('updated@example.com', updatedCust.Customer_Email__c);
  //     System.assertEquals('Updated Name', updatedCust.Customer_Name__c);
  //     System.assertEquals('9999999999', updatedCust.Customer_Phone__c);
  //     System.assertEquals('pm_UPDATED', updatedCust.Default_Payment_Method__c);
  //   }

  //   @IsTest
  //   static void testCustomerUpdateDmlException() {
  //     // Insert a dummy customer that will cause a DML failure (by using a field that violates validation rules if any)
  //     // For safety in this demo, we'll simulate by mocking with an invalid Id in JSON
  //     Stripe_Customer__c cust = new Stripe_Customer__c(
  //       Stripe_Customer_ID__c = 'cus_DMLFAIL'
  //     );
  //     insert cust;

  //     // Payload with a customer id that does not exist in DB to trigger QueryException or DML issues
  //     String body =
  //       '{' +
  //       '"id": "evt_test_003",' +
  //       '"type": "customer.updated",' +
  //       '"data": {' +
  //       '  "object_x": {' +
  //       '    "id": "cus_DOESNOTEXIST",' +
  //       '    "email": "fail@example.com",' +
  //       '    "name": "Fail Name",' +
  //       '    "phone": "0000000000",' +
  //       '    "default_source": "pm_FAIL"' +
  //       '  }' +
  //       '}' +
  //       '}';

  //     Test.startTest();
  //     Integer result;
  //     try {
  //       result = new StripeCustomerWebhookStrategy().handle(body);
  //     } catch (Exception e) {
  //       // In case query throws, treat as handled
  //       result = 422;
  //     }
  //     Test.stopTest();

  //     System.assertEquals(422, result, 'Should return 422 for DML failure');
  //   }

  @isTest
  static void testCustomerCreateSuccess() {
    Stripe_Customer__c cus = StripeTestDataFactory.createStripeCustomer(true);
    String body = StripeWebhookTestFixtures.customerEvents(
      'cus_123',
      'customer.created',
      cus.Customer_Email__c
    );
    test.startTest();
    Integer result = new StripeCustomerWebhookStrategy().handle(body);
    test.stopTest();
    Assert.areEqual(201, result, 'Expected status code 201. Actual ' + result);
  }
}
