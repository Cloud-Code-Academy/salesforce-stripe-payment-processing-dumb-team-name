@isTest
private class StripeWebhookCustomerWrapperTest {
  @isTest
  static void testParseWrapper() {
    // Build a sample JSON string matching the wrapper structure
    String jsonBody =
      '{' +
      '  "id": "evt_12345",' +
      '  "object_x": "event",' +
      '  "type": "customer.created",' +
      '  "data": {' +
      '    "object_x": {' +
      '      "id": "cus_67890",' +
      '      "object_x": "customer",' +
      '      "default_source": "card_abc123",' +
      '      "email": "test@example.com",' +
      '      "name": "Test Customer",' +
      '      "phone": "+15555550123"' +
      '    }' +
      '  }' +
      '}';

    // Call parse method
    StripeWebhookCustomerWrapper wrapper = StripeWebhookCustomerWrapper.parse(
      jsonBody
    );

    // Assert top-level fields
    System.assertEquals('evt_12345', wrapper.id);
    System.assertEquals('event', wrapper.object_x);
    System.assertEquals('customer.created', wrapper.type);

    // Assert nested fields
    System.assertNotEquals(null, wrapper.data);
    System.assertNotEquals(null, wrapper.data.object_x);
    System.assertEquals('cus_67890', wrapper.data.object_x.id);
    System.assertEquals('customer', wrapper.data.object_x.object_x);
    System.assertEquals('card_abc123', wrapper.data.object_x.default_source);
    System.assertEquals('test@example.com', wrapper.data.object_x.email);
    System.assertEquals('Test Customer', wrapper.data.object_x.name);
    System.assertEquals('+15555550123', wrapper.data.object_x.phone);
  }
}
