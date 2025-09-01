@IsTest
public class StripeWebhookSubscriptionWrapperTest {
  @IsTest
  static void testParseSubscriptionWrapper_FullCoverage() {
    // Build JSON string that exercises every field in the wrapper
    String jsonString =
      '{' +
      '"id": "evt_123",' +
      '"type": "customer.subscription.created",' +
      '"created": 1756531800,' +
      '"currency_x": "usd",' +
      '"customer": "cus_456",' +
      '"data": {' +
      '  "object_x": {' +
      '    "id": "sub_789",' +
      '    "object_x": "subscription",' +
      '    "metadata": { "Salesforce_Subscription_Id": "a1B123" },' +
      '    "items": {' +
      '      "object_x": "list",' +
      '      "data": [' +
      '        {' +
      '          "id": "si_001",' +
      '          "object_x": "subscription_item",' +
      '          "current_period_end": 1756531800,' +
      '          "current_period_start": 1756531200,' +
      '          "quantity": 3,' +
      '          "plan": {' +
      '            "id": "plan_001",' +
      '            "object_x": "plan",' +
      '            "active": true,' +
      '            "amount": 5000,' +
      '            "amount_decimal": "5000",' +
      '            "billing_scheme": "per_unit",' +
      '            "created": 1756531000,' +
      '            "currency_x": "usd",' +
      '            "product": "prod_001"' +
      '          },' +
      '          "price": {' +
      '            "id": "price_001",' +
      '            "object_x": "price",' +
      '            "active": true,' +
      '            "created": 1756531001,' +
      '            "currency_x": "usd",' +
      '            "product": "prod_001"' +
      '          }' +
      '        }' +
      '      ]' +
      '    }' +
      '  }' +
      '}' +
      '}';

    // Act
    StripeWebhookSubscriptionWrapper wrapper = StripeWebhookSubscriptionWrapper.parse(
      jsonString
    );

    // Assert top-level fields
    System.assertEquals('evt_123', wrapper.id);
    System.assertEquals('customer.subscription.created', wrapper.type);
    System.assertEquals(1756531800, wrapper.created);
    System.assertEquals('usd', wrapper.currency_x);
    System.assertEquals('cus_456', wrapper.customer);

    // Assert subscription object
    StripeWebhookSubscriptionWrapper.SubscriptionWrapper sub = wrapper.data.object_x;
    System.assertEquals('sub_789', sub.id);
    System.assertEquals('subscription', sub.object_x);
    System.assertEquals('a1B123', sub.metadata.Salesforce_Subscription_Id);

    // Assert items
    System.assertEquals('list', sub.items.object_x);
    System.assertEquals(1, sub.items.data.size());

    // Assert subscription item
    StripeWebhookSubscriptionWrapper.SubscriptionItemWrapper item = sub.items.data[0];
    System.assertEquals('si_001', item.id);
    System.assertEquals('subscription_item', item.object_x);
    System.assertEquals(1756531800, item.current_period_end);
    System.assertEquals(1756531200, item.current_period_start);
    System.assertEquals(3, item.quantity);

    // Assert plan
    System.assertEquals('plan_001', item.plan.id);
    System.assertEquals(true, item.plan.active);
    System.assertEquals(5000, item.plan.amount);
    System.assertEquals('5000', item.plan.amount_decimal);
    System.assertEquals('per_unit', item.plan.billing_scheme);
    System.assertEquals('prod_001', item.plan.product);

    // Assert price
    System.assertEquals('price_001', item.price.id);
    System.assertEquals(true, item.price.active);
    System.assertEquals('usd', item.price.currency_x);
    System.assertEquals('prod_001', item.price.product);
  }
}
