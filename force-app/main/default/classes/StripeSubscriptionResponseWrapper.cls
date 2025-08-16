public with sharing class StripeSubscriptionResponseWrapper {
    
        public String id { get; set; }
        public String status { get; set; }
        public String stripeCurrency { get; set; }
        public String customer { get; set; }
        public Long current_period_start { get; set; }
        public Long current_period_end { get; set; }
        public StripeItems items { get; set; }

        public class StripeItems {
            public String stripeObject { get; set; }
            public List<StripeItem> data { get; set; }
        }

        public class StripeItem {
            public String id { get; set; }
            public String stripeObject { get; set; }
            public StripePlan plan { get; set; }
            public StripePrice price { get; set; }
            public Integer quantity { get; set; }
        }

        public class StripePlan {
            public String id { get; set; }
            public String stripeObject { get; set; }
            public Integer amount { get; set; }
            public String stripeCurrency { get; set; }
            public String interval { get; set; }
            public Integer interval_count { get; set; }
        }

        public class StripePrice {
            public String id { get; set; }
            public String stripeObject { get; set; }
            public Integer unit_amount { get; set; }
            public String stripeCurrency { get; set; }
    }
}
    


//     {
//     "id": "sub_1RvUHW1tjuPU70mUyuJLbH9n",
//     "object": "subscription",
//     "application": null,
//     "application_fee_percent": null,
//     "automatic_tax": {
//         "disabled_reason": null,
//         "enabled": false,
//         "liability": null
//     },
//     "billing_cycle_anchor": 1755051554,
//     "billing_cycle_anchor_config": null,
//     "billing_mode": {
//         "type": "classic"
//     },
//     "billing_thresholds": null,
//     "cancel_at": null,
//     "cancel_at_period_end": false,
//     "canceled_at": null,
//     "cancellation_details": {
//         "comment": null,
//         "feedback": null,
//         "reason": null
//     },
//     "collection_method": "charge_automatically",
//     "created": 1755051554,
//     "currency": "usd",
//     "customer": "cus_SqpkZEpOLEI3I0",
//     "days_until_due": null,
//     "default_payment_method": null,
//     "default_source": null,
//     "default_tax_rates": [],
//     "description": null,
//     "discounts": [],
//     "ended_at": null,
//     "invoice_settings": {
//         "account_tax_ids": null,
//         "issuer": {
//             "type": "self"
//         }
//     },
//     "items": {
//         "object": "list",
//         "data": [
//             {
//                 "id": "si_SrCgTEfteJBLNh",
//                 "object": "subscription_item",
//                 "billing_thresholds": null,
//                 "created": 1755051555,
//                 "current_period_end": 1757729954,
//                 "current_period_start": 1755051554,
//                 "discounts": [],
//                 "metadata": {},
//                 "plan": {
//                     "id": "price_1RvUHW1tjuPU70mU8RJ6D8KW",
//                     "object": "plan",
//                     "active": false,
//                     "amount": 500,
//                     "amount_decimal": "500",
//                     "billing_scheme": "per_unit",
//                     "created": 1755051554,
//                     "currency": "usd",
//                     "interval": "month",
//                     "interval_count": 1,
//                     "livemode": false,
//                     "metadata": {},
//                     "meter": null,
//                     "nickname": null,
//                     "product": "prod_SoyJE1PoKahFTG",
//                     "tiers_mode": null,
//                     "transform_usage": null,
//                     "trial_period_days": null,
//                     "usage_type": "licensed"
//                 },
//                 "price": {
//                     "id": "price_1RvUHW1tjuPU70mU8RJ6D8KW",
//                     "object": "price",
//                     "active": false,
//                     "billing_scheme": "per_unit",
//                     "created": 1755051554,
//                     "currency": "usd",
//                     "custom_unit_amount": null,
//                     "livemode": false,
//                     "lookup_key": null,
//                     "metadata": {},
//                     "nickname": null,
//                     "product": "prod_SoyJE1PoKahFTG",
//                     "recurring": {
//                         "interval": "month",
//                         "interval_count": 1,
//                         "meter": null,
//                         "trial_period_days": null,
//                         "usage_type": "licensed"
//                     },
//                     "tax_behavior": "unspecified",
//                     "tiers_mode": null,
//                     "transform_quantity": null,
//                     "type": "recurring",
//                     "unit_amount": 500,
//                     "unit_amount_decimal": "500"
//                 },
//                 "quantity": 1,
//                 "subscription": "sub_1RvUHW1tjuPU70mUyuJLbH9n",
//                 "tax_rates": []
//             }
//         ],
//         "has_more": false,
//         "total_count": 1,
//         "url": "/v1/subscription_items?subscription=sub_1RvUHW1tjuPU70mUyuJLbH9n"
//     },
//     "latest_invoice": "in_1RvUHW1tjuPU70mUDHx4A2BU",
//     "livemode": false,
//     "metadata": {},
//     "next_pending_invoice_item_invoice": null,
//     "on_behalf_of": null,
//     "pause_collection": null,
//     "payment_settings": {
//         "payment_method_options": null,
//         "payment_method_types": null,
//         "save_default_payment_method": "off"
//     },
//     "pending_invoice_item_interval": null,
//     "pending_setup_intent": null,
//     "pending_update": null,
//     "plan": {
//         "id": "price_1RvUHW1tjuPU70mU8RJ6D8KW",
//         "object": "plan",
//         "active": false,
//         "amount": 500,
//         "amount_decimal": "500",
//         "billing_scheme": "per_unit",
//         "created": 1755051554,
//         "currency": "usd",
//         "interval": "month",
//         "interval_count": 1,
//         "livemode": false,
//         "metadata": {},
//         "meter": null,
//         "nickname": null,
//         "product": "prod_SoyJE1PoKahFTG",
//         "tiers_mode": null,
//         "transform_usage": null,
//         "trial_period_days": null,
//         "usage_type": "licensed"
//     },
//     "quantity": 1,
//     "schedule": null,
//     "start_date": 1755051554,
//     "status": "active",
//     "test_clock": null,
//     "transfer_data": null,
//     "trial_end": null,
//     "trial_settings": {
//         "end_behavior": {
//             "missing_payment_method": "create_invoice"
//         }
//     },
//     "trial_start": null
// }