@IsTest
public class StripeWebhookSubscriptionWrapperTest {
  @IsTest
  static void testParseSubscriptionWrapper_FullCoverage() {
    String jsonString =
      '{' +
      '  \"id\": \"evt_1S2Nmz4hwnEBsWxgywdAa4tJ\",' +
      '  \"object_x\": \"event\",' +
      '  \"api_version\": \"2025-05-28.basil\",' +
      '  \"created\": 1756694893,' +
      '  \"data\": {' +
      '    \"object_x\": {' +
      '      \"id\": \"sub_1S2Nmx4hwnEBsWxgVRQ66HsJ\",' +
      '      \"object_x\": \"subscription\",' +
      '      \"application\": null,' +
      '      \"application_fee_percent\": null,' +
      '      \"automatic_tax\": {' +
      '        \"disabled_reason\": null,' +
      '        \"enabled\": false,' +
      '        \"liability\": null' +
      '      },' +
      '      \"billing_cycle_anchor\": 1756694890,' +
      '      \"billing_cycle_anchor_config\": null,' +
      '      \"billing_mode\": {' +
      '        \"type\": \"classic\"' +
      '      },' +
      '      \"billing_thresholds\": null,' +
      '      \"cancel_at\": null,' +
      '      \"cancel_at_period_end\": false,' +
      '      \"canceled_at\": null,' +
      '      \"cancellation_details\": {' +
      '        \"comment\": null,' +
      '        \"feedback\": null,' +
      '        \"reason\": null' +
      '      },' +
      '      \"collection_method\": \"charge_automatically\",' +
      '      \"created\": 1756694890,' +
      '      \"currency_x\": \"cad\",' +
      '      \"customer\": \"cus_SxQXkckgaFFb0I\",' +
      '      \"days_until_due\": null,' +
      '      \"default_payment_method\": null,' +
      '      \"default_source\": \"card_1S2Nmt4hwnEBsWxgEReH53ac\",' +
      '      \"default_tax_rates\": [],' +
      '      \"description\": null,' +
      '      \"discounts\": [],' +
      '      \"ended_at\": null,' +
      '      \"invoice_settings\": {' +
      '        \"account_tax_ids\": null,' +
      '        \"issuer\": {' +
      '          \"type\": \"self\"' +
      '        }' +
      '      },' +
      '      \"items\": {' +
      '        \"object_x\": \"list\",' +
      '        \"data\": [' +
      '          {' +
      '            \"id\": \"si_SyKRD8SxCOe0rQ\",' +
      '            \"object_x\": \"subscription_item\",' +
      '            \"billing_thresholds\": null,' +
      '            \"created\": 1756694891,' +
      '            \"current_period_end\": 1757299690,' +
      '            \"current_period_start\": 1756694890,' +
      '            \"discounts\": [],' +
      '            \"metadata\": {},' +
      '            \"plan\": {' +
      '              \"id\": \"price_1Rwb2Y4hwnEBsWxgMVZI0PJP\",' +
      '              \"object_x\": \"plan\",' +
      '              \"active\": true,' +
      '              \"amount\": 2000,' +
      '              \"amount_decimal\": \"2000\",' +
      '              \"billing_scheme\": \"per_unit\",' +
      '              \"created\": 1755315862,' +
      '              \"currency_x\": \"cad\",' +
      '              \"interval\": \"week\",' +
      '              \"interval_count\": 1,' +
      '              \"livemode\": false,' +
      '              \"metadata\": {},' +
      '              \"meter\": null,' +
      '              \"nickname\": null,' +
      '              \"product\": \"prod_SsLkueCbl8d0Bk\",' +
      '              \"tiers_mode\": null,' +
      '              \"transform_usage\": null,' +
      '              \"trial_period_days\": null,' +
      '              \"usage_type\": \"licensed\"' +
      '            },' +
      '            \"price\": {' +
      '              \"id\": \"price_1Rwb2Y4hwnEBsWxgMVZI0PJP\",' +
      '              \"object_x\": \"price\",' +
      '              \"active\": true,' +
      '              \"billing_scheme\": \"per_unit\",' +
      '              \"created\": 1755315862,' +
      '              \"currency_x\": \"cad\",' +
      '              \"custom_unit_amount\": null,' +
      '              \"livemode\": false,' +
      '              \"lookup_key\": \"Premium_Hotdogs-680e460\",' +
      '              \"metadata\": {},' +
      '              \"nickname\": null,' +
      '              \"product\": \"prod_SsLkueCbl8d0Bk\",' +
      '              \"recurring\": {' +
      '                \"interval\": \"week\",' +
      '                \"interval_count\": 1,' +
      '                \"meter\": null,' +
      '                \"trial_period_days\": null,' +
      '                \"usage_type\": \"licensed\"' +
      '              },' +
      '              \"tax_behavior\": \"unspecified\",' +
      '              \"tiers_mode\": null,' +
      '              \"transform_quantity\": null,' +
      '              \"type\": \"recurring\",' +
      '              \"unit_amount\": 2000,' +
      '              \"unit_amount_decimal\": \"2000\"' +
      '            },' +
      '            \"quantity\": 1,' +
      '            \"subscription\": \"sub_1S2Nmx4hwnEBsWxgVRQ66HsJ\",' +
      '            \"tax_rates\": []' +
      '          }' +
      '        ],' +
      '        \"has_more\": false,' +
      '        \"total_count\": 1,' +
      '        \"url\": \"/v1/subscription_items?subscription=sub_1S2Nmx4hwnEBsWxgVRQ66HsJ\"' +
      '      },' +
      '      \"latest_invoice\": \"in_1S2Nmx4hwnEBsWxgKMDLoYXI\",' +
      '      \"livemode\": false,' +
      '      \"metadata\": {' +
      '        \"Salesforce_Subscription_Id\": \"a02gK000004ZdDuQAK\"' +
      '      },' +
      '      \"next_pending_invoice_item_invoice\": null,' +
      '      \"on_behalf_of\": null,' +
      '      \"pause_collection\": null,' +
      '      \"payment_settings\": {' +
      '        \"payment_method_options\": null,' +
      '        \"payment_method_types\": null,' +
      '        \"save_default_payment_method\": \"off\"' +
      '      },' +
      '      \"pending_invoice_item_interval\": null,' +
      '      \"pending_setup_intent\": null,' +
      '      \"pending_update\": null,' +
      '      \"plan\": {' +
      '        \"id\": \"price_1Rwb2Y4hwnEBsWxgMVZI0PJP\",' +
      '        \"object_x\": \"plan\",' +
      '        \"active\": true,' +
      '        \"amount\": 2000,' +
      '        \"amount_decimal\": \"2000\",' +
      '        \"billing_scheme\": \"per_unit\",' +
      '        \"created\": 1755315862,' +
      '        \"currency_x\": \"cad\",' +
      '        \"interval\": \"week\",' +
      '        \"interval_count\": 1,' +
      '        \"livemode\": false,' +
      '        \"metadata\": {},' +
      '        \"meter\": null,' +
      '        \"nickname\": null,' +
      '        \"product\": \"prod_SsLkueCbl8d0Bk\",' +
      '        \"tiers_mode\": null,' +
      '        \"transform_usage\": null,' +
      '        \"trial_period_days\": null,' +
      '        \"usage_type\": \"licensed\"' +
      '      },' +
      '      \"quantity\": 1,' +
      '      \"schedule\": null,' +
      '      \"start_date\": 1756694890,' +
      '      \"status\": \"active\",' +
      '      \"test_clock\": null,' +
      '      \"transfer_data\": null,' +
      '      \"trial_end\": null,' +
      '      \"trial_settings\": {' +
      '        \"end_behavior\": {' +
      '          \"missing_payment_method\": \"create_invoice\"' +
      '        }' +
      '      },' +
      '      \"trial_start\": null' +
      '    }' +
      '  },' +
      '  \"livemode\": false,' +
      '  \"pending_webhooks\": 1,' +
      '  \"request\": {' +
      '    \"id\": \"req_HO0NIPO2aW9csw\",' +
      '    \"idempotency_key\": \"5c9bc4f2-fd77-4971-809d-d97a41a2af08\"' +
      '  },' +
      '  \"type\": \"customer.subscription.created\"' +
      '}';

    StripeWebhookSubscriptionWrapper wrapper = StripeWebhookSubscriptionWrapper.parse(
      jsonString
    );

    System.assertEquals(
      'evt_1S2Nmz4hwnEBsWxgywdAa4tJ',
      wrapper.id,
      'Event Id does not have the expected value'
    );
    System.assertEquals(
      'customer.subscription.created',
      wrapper.type,
      'Event type expected: customer.subscription.created. Actual: ' +
      wrapper.type
    );
    System.assertEquals(
      1756694893,
      wrapper.created,
      'Created value expected: 1756694893. Actual: ' + wrapper.created
    );
    System.assertEquals(
      'cad',
      wrapper.data.object_x.currency_x,
      'Currency value expected: cad. Actual: ' +
      wrapper.data.object_x.currency_x
    );
    System.assertEquals(
      'cus_SxQXkckgaFFb0I',
      wrapper.data.object_x.customer,
      'Customer value expected: cus_SxQXkckgaFFb0I. Actual: ' +
      wrapper.data.object_x.customer
    );

    System.assertEquals(
      'sub_1S2Nmx4hwnEBsWxgVRQ66HsJ',
      wrapper.data.object_x.id,
      'Expected: sub_1S2Nmx4hwnEBsWxgVRQ66HsJ. Actual: ' +
      wrapper.data.object_x.id
    );
    System.assertEquals(
      'subscription',
      wrapper.data.object_x.object_x,
      'Expected: subscription. Actual: ' + wrapper.data.object_x.object_x
    );
    System.assertEquals(
      'a02gK000004ZdDuQAK',
      wrapper.data.object_x.metadata.Salesforce_Subscription_Id,
      'Expected: a02gK000004ZdDuQAK. Actual: ' +
      wrapper.data.object_x.metadata.Salesforce_Subscription_Id
    );

    System.assertEquals(
      'list',
      wrapper.data.object_x.items.object_x,
      'Expected: list. Actual: ' + wrapper.data.object_x.items.object_x
    );
    System.assertEquals(
      1,
      wrapper.data.object_x.items.data.size(),
      'Expected size of item list: 1. Actual size of item list: ' +
      wrapper.data.object_x.items.data.size()
    );

    System.assertEquals(
      'si_SyKRD8SxCOe0rQ',
      wrapper.data.object_x.items.data[0].id,
      'Expected list item id: si_SyKRD8SxCOe0rQ. Actual: ' +
      wrapper.data.object_x.items.data[0].id
    );
    System.assertEquals(
      'subscription_item',
      wrapper.data.object_x.items.data[0].object_x,
      'Expected value: subcription_item. Actual: ' +
      wrapper.data.object_x.items.data[0].object_x
    );
    System.assertEquals(
      1757299690,
      wrapper.data.object_x.items.data[0].current_period_end,
      'Expected: 1757299690. Actual: ' +
      wrapper.data.object_x.items.data[0].current_period_end
    );
    System.assertEquals(
      1756694890,
      wrapper.data.object_x.items.data[0].current_period_start,
      'Expected: 1756694890. Actual: ' +
      wrapper.data.object_x.items.data[0].current_period_start
    );
    System.assertEquals(
      1,
      wrapper.data.object_x.items.data[0].quantity,
      'Expected: 1, Actual: ' + wrapper.data.object_x.items.data[0].quantity
    );

    System.assertEquals(
      'price_1Rwb2Y4hwnEBsWxgMVZI0PJP',
      wrapper.data.object_x.items.data[0].price.id,
      'Expected: price_1Rwb2Y4hwnEBsWxgMVZI0PJP. Actual: ' +
      wrapper.data.object_x.items.data[0].price.id
    );
    System.assertEquals(
      true,
      wrapper.data.object_x.items.data[0].plan.active,
      'Excepted plan status active. Actual plan status: ' +
      wrapper.data.object_x.items.data[0].plan.active
    );
    System.assertEquals(
      2000,
      wrapper.data.object_x.items.data[0].plan.amount,
      'Expected plan amount: 2000. Actual plan amount: ' +
      wrapper.data.object_x.items.data[0].plan.amount
    );
    System.assertEquals(
      '2000',
      wrapper.data.object_x.items.data[0].plan.amount_decimal,
      'Expected amount decimal: 2000. Actual: ' +
      wrapper.data.object_x.items.data[0].plan.amount_decimal
    );
    System.assertEquals(
      'per_unit',
      wrapper.data.object_x.items.data[0].plan.billing_scheme,
      'Expected billing scheme: per_unit. Actual: ' +
      wrapper.data.object_x.items.data[0].plan.billing_scheme
    );
    System.assertEquals(
      'prod_SsLkueCbl8d0Bk',
      wrapper.data.object_x.items.data[0].plan.product,
      'Expected product: prod_SsLkueCbl8d0Bk. Actual product: ' +
      wrapper.data.object_x.items.data[0].plan.product
    );

    System.assertEquals(
      'price_1Rwb2Y4hwnEBsWxgMVZI0PJP',
      wrapper.data.object_x.items.data[0].price.id,
      'Expected price id: price_1Rwb2Y4hwnEBsWxgMVZI0PJP. Actual: ' +
      wrapper.data.object_x.items.data[0].price.id
    );
    System.assertEquals(
      true,
      wrapper.data.object_x.items.data[0].price.active,
      'Expected status: active. Actual: ' +
      wrapper.data.object_x.items.data[0].price.active
    );
    System.assertEquals(
      'cad',
      wrapper.data.object_x.items.data[0].price.currency_x,
      'Expected currency: cad. Actual: ' +
      wrapper.data.object_x.items.data[0].price.currency_x
    );
    System.assertEquals(
      'prod_SsLkueCbl8d0Bk',
      wrapper.data.object_x.items.data[0].plan.product,
      'Expected: prod_SsLkueCbl8d0Bk. Actual: ' +
      wrapper.data.object_x.items.data[0].plan.product
    );
    System.assertEquals(
      'Premium_Hotdogs-680e460',
      wrapper.data.object_x.items.data[0].price.lookup_key,
      'Expected value: Premium_Hotdogs-680e460. Actual value: ' +
      wrapper.data.object_x.items.data[0].price.lookup_key
    );
  }
}
