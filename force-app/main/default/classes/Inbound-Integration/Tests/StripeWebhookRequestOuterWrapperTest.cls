@isTest
public with sharing class StripeWebhookRequestOuterWrapperTest {
  @isTest
  static void testGetEventTypeValid() {
    String body = '{"id":"evt_test","type":"customer.updated"}';

    Test.startTest();

    String eventType = StripeWebhookRequestOuterWrapper.getEventType(body);

    Test.stopTest();

    Assert.areEqual(
      'customer.updated',
      eventType,
      'Value returned from getEventType() does not match expected value.'
    );
  }

  @isTest
  static void testNormaliseEventTypeValid() {
    String eventType = 'customer.updated';
    Test.startTest();
    String normalised = StripeWebhookRequestOuterWrapper.normaliseEventType(
      eventType
    );
    Test.stopTest();
    Assert.areEqual(
      'customer_updated',
      normalised,
      'Correct normalised value not returned'
    );
  }
}
