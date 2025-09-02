@isTest
public with sharing class StripeWebhookInvoiceWrapperTest {
  @isTest
  static void testParseInvoiceWrapper() {
    // Build a JSON string that matches the structure of StripeWebhookInvoiceWrapper
    String jsonString =
      '{' +
      '"id": "evt_test123",' +
      '"object_x": "event",' +
      '"created": 1756531800,' +
      '"type": "invoice.paid",' +
      '"data": {' +
      '   "object_x": {' +
      '       "id": "in_test456",' +
      '       "object_x": "invoice",' +
      '       "amount_paid": 2000,' +
      '       "currency_x": "usd",' +
      '       "customer": "cus_789",' +
      '       "invoice_pdf": "https://stripe.com/test.pdf",' +
      '       "period_end": 1756531800,' +
      '       "period_start": 1756520000,' +
      '       "status": "paid",' +
      '       "lines": {' +
      '           "data": [' +
      '               {' +
      '                   "id": "li_001",' +
      '                   "object_x": "line_item",' +
      '                   "metadata": {' +
      '                       "Salesforce_Subscription_Id": "a02gK00000Sub123"' +
      '                   }' +
      '               }' +
      '           ]' +
      '       }' +
      '   }' +
      '}' +
      '}';

    // Call parse method
    StripeWebhookInvoiceWrapper wrapper = StripeWebhookInvoiceWrapper.parse(
      jsonString
    );

    // Assertions to cover all fields
    System.assertNotEquals(null, wrapper);
    System.assertEquals('evt_test123', wrapper.id);
    System.assertEquals('event', wrapper.object_x);
    System.assertEquals(1756531800, wrapper.created);
    System.assertEquals('invoice.paid', wrapper.type);

    // Validate nested InvoiceWrapper
    StripeWebhookInvoiceWrapper.InvoiceWrapper invoice = wrapper.data.object_x;
    System.assertEquals('in_test456', invoice.id);
    System.assertEquals('invoice', invoice.object_x);
    System.assertEquals(2000, invoice.amount_paid);
    System.assertEquals('usd', invoice.currency_x);
    System.assertEquals('cus_789', invoice.customer);
    System.assertEquals('https://stripe.com/test.pdf', invoice.invoice_pdf);
    System.assertEquals(1756531800, invoice.period_end);
    System.assertEquals(1756520000, invoice.period_start);
    System.assertEquals('paid', invoice.status);

    // Validate line items
    System.assertNotEquals(null, invoice.lines);
    System.assertEquals(1, invoice.lines.data.size());
    StripeWebhookInvoiceWrapper.LineItemWrapper lineItem = invoice.lines.data[0];
    System.assertEquals('li_001', lineItem.id);
    System.assertEquals('line_item', lineItem.object_x);
    System.assertEquals(
      'a02gK00000Sub123',
      lineItem.metadata.Salesforce_Subscription_Id
    );

    // Cover SubscriptionDetails class
    StripeWebhookInvoiceWrapper.SubscriptionDetails subDetails = new StripeWebhookInvoiceWrapper.SubscriptionDetails();
    subDetails.subscription = 'sub_999';
    System.assertEquals('sub_999', subDetails.subscription);
  }
}
