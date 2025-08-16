public with sharing class StripeSubscriptionRequestWrapper {
    public String currency;
    public String priceId;
    public String recurringInterval;
    public Decimal unitAmount;
    public String customerId;

    public StripeSubscriptionRequestWrapper(
        String stripeCurrency,
        String priceId,
        String recurringInterval,
        Decimal unitAmount,
        String customerId
    ) {
        this.stripeCurrency = stripeCurrency;
        this.priceId = priceId;
        this.recurringInterval = recurringInterval;
        this.unitAmount = unitAmount;
        this.customerId = customerId;
    }
    public String toUrlEncodedString() {
        return 'stripeCurrency=' + EncodingUtil.urlEncode(stripeCurrency, 'UTF-8') +
               '&price=' + EncodingUtil.urlEncode(priceId, 'UTF-8') +
               '&recurring[interval]=' + EncodingUtil.urlEncode(recurringInterval, 'UTF-8') +
               '&unit_amount=' + EncodingUtil.urlEncode(String.valueOf(unitAmount), 'UTF-8') +
               '&customer=' + EncodingUtil.urlEncode(customerId, 'UTF-8');
    }
}

// {
//     "id": "sub_1RvpVc1tjuPU70mUghFtlEtz",
//     "object": "subscription",
//     "application": null,
//     "application_fee_percent": null,
//     "automatic_tax": {
//         "disabled_reason": null,
//         "enabled": false,
//         "liability": null
//     },
//     "billing_cycle_anchor": 1755133152,
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
//     "created": 1755133152,
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
//                 "id": "si_SrYcvztM0N9nvG",
//                 "object": "subscription_item",
//                 "billing_thresholds": null,
//                 "created": 1755133153,
//                 "current_period_end": 1757811552,
//                 "current_period_start": 1755133152,
//                 "discounts": [],
//                 "metadata": {},
//                 "plan": {
//                     "id": "price_1RvpVc1tjuPU70mUJE3TkokT",
//                     "object": "plan",
//                     "active": false,
//                     "amount": 500,
//                     "amount_decimal": "500",
//                     "billing_scheme": "per_unit",
//                     "created": 1755133152,
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
//                     "id": "price_1RvpVc1tjuPU70mUJE3TkokT",
//                     "object": "price",
//                     "active": false,
//                     "billing_scheme": "per_unit",
//                     "created": 1755133152,
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
//                 "subscription": "sub_1RvpVc1tjuPU70mUghFtlEtz",
//                 "tax_rates": []
//             }
//         ],
//         "has_more": false,
//         "total_count": 1,
//         "url": "/v1/subscription_items?subscription=sub_1RvpVc1tjuPU70mUghFtlEtz"
//     },
//     "latest_invoice": "in_1RvpVc1tjuPU70mUJXEuops8",
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
//         "id": "price_1RvpVc1tjuPU70mUJE3TkokT",
//         "object": "plan",
//         "active": false,
//         "amount": 500,
//         "amount_decimal": "500",
//         "billing_scheme": "per_unit",
//         "created": 1755133152,
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
//     "start_date": 1755133152,
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
}