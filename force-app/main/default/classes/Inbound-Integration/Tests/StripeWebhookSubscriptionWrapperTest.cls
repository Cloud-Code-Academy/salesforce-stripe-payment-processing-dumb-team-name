@isTest
public with sharing class StripeWebhookSubscriptionWrapperTest {
  @isTest
  static void testParse() {
    String json =
      '{' +
      '  "id": "evt_1Rz0Hd4hwnEBsWxgtcqaRL5N",' +
      '  "object": "event",' +
      '  "api_version": "2025-05-28.basil",' +
      '  "created": 1755889553,' +
      '  "data": {' +
      '    "object": {' +
      '      "id": "sub_1RwbCy4hwnEBsWxgVxLeHnl4",' +
      '      "object": "subscription",' +
      '      "application": null,' +
      '      "application_fee_percent": null,' +
      '      "automatic_tax": {' +
      '        "disabled_reason": null,' +
      '        "enabled": false,' +
      '        "liability": null' +
      '      },' +
      '      "billing_cycle_anchor": 1755316508,' +
      '      "billing_cycle_anchor_config": null,' +
      '      "billing_mode": {' +
      '        "type": "classic"' +
      '      },' +
      '      "billing_thresholds": null,' +
      '      "cancel_at": 1762574108,' +
      '      "cancel_at_period_end": false,' +
      '      "canceled_at": 1755889552,' +
      '      "cancellation_details": {' +
      '        "comment": null,' +
      '        "feedback": null,' +
      '        "reason": "cancellation_requested"' +
      '      },' +
      '      "collection_method": "charge_automatically",' +
      '      "created": 1755316508,' +
      '      "currency": "cad",' +
      '      "customer": "cus_SsFuuZiYsuPb1f",' +
      '      "days_until_due": null,' +
      '      "default_payment_method": null,' +
      '      "default_source": null,' +
      '      "default_tax_rates": [],' +
      '      "description": null,' +
      '      "discounts": [],' +
      '      "ended_at": null,' +
      '      "invoice_settings": {' +
      '        "account_tax_ids": null,' +
      '        "issuer": {' +
      '          "type": "self"' +
      '        }' +
      '      },' +
      '      "items": {' +
      '        "object": "list",' +
      '        "data": [' +
      '          {' +
      '            "id": "si_Supx1o3IWkY4Dg",' +
      '            "object": "subscription_item",' +
      '            "billing_thresholds": null,' +
      '            "created": 1755889553,' +
      '            "current_period_end": 1755921308,' +
      '            "current_period_start": 1755316508,' +
      '            "discounts": [],' +
      '            "metadata": {},' +
      '            "plan": {' +
      '              "id": "price_1Rz0Hc4hwnEBsWxgyJGgzHbj",' +
      '              "object": "plan",' +
      '              "active": false,' +
      '              "amount": 3300,' +
      '              "amount_decimal": "3300",' +
      '              "billing_scheme": "per_unit",' +
      '              "created": 1755889552,' +
      '              "currency": "cad",' +
      '              "interval": "week",' +
      '              "interval_count": 1,' +
      '              "livemode": false,' +
      '              "metadata": {},' +
      '              "meter": null,' +
      '              "nickname": null,' +
      '              "product": "prod_SsLkueCbl8d0Bk",' +
      '              "tiers_mode": null,' +
      '              "transform_usage": null,' +
      '              "trial_period_days": null,' +
      '              "usage_type": "licensed"' +
      '            },' +
      '            "price": {' +
      '              "id": "price_1Rz0Hc4hwnEBsWxgyJGgzHbj",' +
      '              "object": "price",' +
      '              "active": false,' +
      '              "billing_scheme": "per_unit",' +
      '              "created": 1755889552,' +
      '              "currency": "cad",' +
      '              "custom_unit_amount": null,' +
      '              "livemode": false,' +
      '              "lookup_key": null,' +
      '              "metadata": {},' +
      '              "nickname": null,' +
      '              "product": "prod_SsLkueCbl8d0Bk",' +
      '              "recurring": {' +
      '                "interval": "week",' +
      '                "interval_count": 1,' +
      '                "meter": null,' +
      '                "trial_period_days": null,' +
      '                "usage_type": "licensed"' +
      '              },' +
      '              "tax_behavior": "unspecified",' +
      '              "tiers_mode": null,' +
      '              "transform_quantity": null,' +
      '              "type": "recurring",' +
      '              "unit_amount": 3300,' +
      '              "unit_amount_decimal": "3300"' +
      '            },' +
      '            "quantity": 2,' +
      '            "subscription": "sub_1RwbCy4hwnEBsWxgVxLeHnl4",' +
      '            "tax_rates": []' +
      '          }' +
      '        ],' +
      '        "has_more": false,' +
      '        "total_count": 1,' +
      '        "url": "/v1/subscription_items?subscription=sub_1RwbCy4hwnEBsWxgVxLeHnl4"' +
      '      },' +
      '      "latest_invoice": "in_1RwbCz4hwnEBsWxgDF7yCQOp",' +
      '      "livemode": false,' +
      '      "metadata": {},' +
      '      "next_pending_invoice_item_invoice": null,' +
      '      "on_behalf_of": null,' +
      '      "pause_collection": null,' +
      '      "payment_settings": {' +
      '        "payment_method_options": null,' +
      '        "payment_method_types": null,' +
      '        "save_default_payment_method": "off"' +
      '      },' +
      '      "pending_invoice_item_interval": null,' +
      '      "pending_setup_intent": null,' +
      '      "pending_update": null,' +
      '      "plan": {' +
      '        "id": "price_1Rz0Hc4hwnEBsWxgyJGgzHbj",' +
      '        "object": "plan",' +
      '        "active": false,' +
      '        "amount": 3300,' +
      '        "amount_decimal": "3300",' +
      '        "billing_scheme": "per_unit",' +
      '        "created": 1755889552,' +
      '        "currency": "cad",' +
      '        "interval": "week",' +
      '        "interval_count": 1,' +
      '        "livemode": false,' +
      '        "metadata": {},' +
      '        "meter": null,' +
      '        "nickname": null,' +
      '        "product": "prod_SsLkueCbl8d0Bk",' +
      '        "tiers_mode": null,' +
      '        "transform_usage": null,' +
      '        "trial_period_days": null,' +
      '        "usage_type": "licensed"' +
      '      },' +
      '      "quantity": 2,' +
      '      "schedule": "sub_sched_1Rz0Hc4hwnEBsWxgDoqCZDXX",' +
      '      "start_date": 1755316508,' +
      '      "status": "active",' +
      '      "test_clock": null,' +
      '      "transfer_data": null,' +
      '      "trial_end": null,' +
      '      "trial_settings": {' +
      '        "end_behavior": {' +
      '          "missing_payment_method": "create_invoice"' +
      '        }' +
      '      },' +
      '      "trial_start": null' +
      '    },' +
      '    "previous_attributes": {' +
      '      "cancel_at": null,' +
      '      "canceled_at": null,' +
      '      "cancellation_details": {' +
      '        "reason": null' +
      '      },' +
      '      "items": {' +
      '        "data": [' +
      '          {' +
      '            "id": "si_SsLuBv2Z0Sn9rR",' +
      '            "object": "subscription_item",' +
      '            "billing_thresholds": null,' +
      '            "created": 1755316509,' +
      '            "current_period_end": 1755921308,' +
      '            "current_period_start": 1755316508,' +
      '            "discounts": [],' +
      '            "metadata": {},' +
      '            "plan": {' +
      '              "id": "price_1Rwb2Y4hwnEBsWxgMVZI0PJP",' +
      '              "object": "plan",' +
      '              "active": true,' +
      '              "amount": 2000,' +
      '              "amount_decimal": "2000",' +
      '              "billing_scheme": "per_unit",' +
      '              "created": 1755315862,' +
      '              "currency": "cad",' +
      '              "interval": "week",' +
      '              "interval_count": 1,' +
      '              "livemode": false,' +
      '              "metadata": {},' +
      '              "meter": null,' +
      '              "nickname": null,' +
      '              "product": "prod_SsLkueCbl8d0Bk",' +
      '              "tiers_mode": null,' +
      '              "transform_usage": null,' +
      '              "trial_period_days": null,' +
      '              "usage_type": "licensed"' +
      '            },' +
      '            "price": {' +
      '              "id": "price_1Rwb2Y4hwnEBsWxgMVZI0PJP",' +
      '              "object": "price",' +
      '              "active": true,' +
      '              "billing_scheme": "per_unit",' +
      '              "created": 1755315862,' +
      '              "currency": "cad",' +
      '              "custom_unit_amount": null,' +
      '              "livemode": false,' +
      '              "lookup_key": "Premium_Hotdogs-680e460",' +
      '              "metadata": {},' +
      '              "nickname": null,' +
      '              "product": "prod_SsLkueCbl8d0Bk",' +
      '              "recurring": {' +
      '                "interval": "week",' +
      '                "interval_count": 1,' +
      '                "meter": null,' +
      '                "trial_period_days": null,' +
      '                "usage_type": "licensed"' +
      '              },' +
      '              "tax_behavior": "unspecified",' +
      '              "tiers_mode": null,' +
      '              "transform_quantity": null,' +
      '              "type": "recurring",' +
      '              "unit_amount": 2000,' +
      '              "unit_amount_decimal": "2000"' +
      '            },' +
      '            "quantity": 1,' +
      '            "subscription": "sub_1RwbCy4hwnEBsWxgVxLeHnl4",' +
      '            "tax_rates": []' +
      '          }' +
      '        ]' +
      '      },' +
      '      "plan": {' +
      '        "id": "price_1Rwb2Y4hwnEBsWxgMVZI0PJP",' +
      '        "active": true,' +
      '        "amount": 2000,' +
      '        "amount_decimal": "2000",' +
      '        "created": 1755315862' +
      '      },' +
      '      "quantity": 1' +
      '    }' +
      '  },' +
      '  "livemode": false,' +
      '  "pending_webhooks": 1,' +
      '  "request": {' +
      '    "id": "req_bdqg1KIkricezO",' +
      '    "idempotency_key": "0fe3365a-1647-454c-920f-059aa67cbc93"' +
      '  },' +
      '  "type": "customer.subscription.updated"' +
      '}';
    StripeWebhookSubscriptionWrapper obj = StripeWebhookSubscriptionWrapper.parse(
      json
    );
    System.assert(obj != null);
  }
}
