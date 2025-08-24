public with sharing class StripeWebhookSubscriptionWrapper {
  public String id { get; set; }
  public String object_x { get; set; }
  public String api_version { get; set; }
  public Long created { get; set; }
  public DataWrapper data { get; set; }
  public Boolean livemode { get; set; }
  public Integer pending_webhooks { get; set; }
  public RequestWrapper request { get; set; }
  public String type { get; set; }

  public class DataWrapper {
    public SubscriptionWrapper object_x { get; set; }
    public PreviousAttributesWrapper previous_attributes { get; set; }
  }

  public class SubscriptionWrapper {
    public String id { get; set; }
    public String object_x { get; set; }
    public Decimal application_fee_percent { get; set; }
    public AutomaticTaxWrapper automatic_tax { get; set; }
    public Long billing_cycle_anchor { get; set; }
    public Object billing_thresholds { get; set; }
    public Object cancel_at { get; set; }
    public Boolean cancel_at_period_end { get; set; }
    public Object canceled_at { get; set; }
    public String collection_method { get; set; }
    public Long created { get; set; }
    public String currency_x { get; set; }
    public Long current_period_end { get; set; }
    public Long current_period_start { get; set; }
    public String customer { get; set; }
    public Object days_until_due { get; set; }
    public String default_payment_method { get; set; }
    public Object default_source { get; set; }
    public List<Object> default_tax_rates { get; set; }
    public Object discount { get; set; }
    public Object ended_at { get; set; }
    public ItemsWrapper items { get; set; }
    public String latest_invoice { get; set; }
    public Boolean livemode { get; set; }
    public Map<String, Object> metadata { get; set; }
    public Object next_pending_invoice_item_invoice { get; set; }
    public Object pause_collection { get; set; }
    public Object pending_invoice_item_interval { get; set; }
    public Object pending_setup_intent { get; set; }
    public Object pending_update { get; set; }
    public PaymentSettingsWrapper payment_settings { get; set; }
    public Object schedule { get; set; }
    public Long start_date { get; set; }
    public String status { get; set; }
    public Object transfer_data { get; set; }
    public Object trial_end { get; set; }
    public Object trial_start { get; set; }
  }

  public class AutomaticTaxWrapper {
    public Boolean enabled { get; set; }
  }

  public class ItemsWrapper {
    public String object_x { get; set; }
    public List<ItemDataWrapper> data { get; set; }
    public Boolean has_more { get; set; }
    public Integer total_count { get; set; }
    public String url { get; set; }
  }

  public class ItemDataWrapper {
    public String id { get; set; }
    public String object_x { get; set; }
    public Object billing_thresholds { get; set; }
    public Long created { get; set; }
    public PriceWrapper price { get; set; }
    public Integer quantity { get; set; }
    public String subscription { get; set; }
    public List<Object> tax_rates { get; set; }
  }

  public class PriceWrapper {
    public String id { get; set; }
    public String object_x { get; set; }
    public Boolean active { get; set; }
    public String currency_x { get; set; }
    public String product { get; set; }
    public RecurringWrapper recurring { get; set; }
    public Integer unit_amount { get; set; }
  }

  public class RecurringWrapper {
    public Object aggregate_usage { get; set; }
    public String interval { get; set; }
    public Integer interval_count { get; set; }
    public String usage_type { get; set; }
  }

  public class PaymentSettingsWrapper {
    public Object payment_method_types { get; set; }
    public String save_default_payment_method { get; set; }
  }

  public class PreviousAttributesWrapper {
    public PreviousItemsWrapper items { get; set; }
  }

  public class PreviousItemsWrapper {
    public List<PreviousItemDataWrapper> data { get; set; }
  }

  public class PreviousItemDataWrapper {
    public PreviousPriceWrapper price { get; set; }
    public Integer quantity { get; set; }
  }

  public class PreviousPriceWrapper {
    public String id { get; set; }
    public Integer unit_amount { get; set; }
  }

  public class RequestWrapper {
    public String id { get; set; }
    public String idempotency_key { get; set; }
  }

  // --- Helper method to parse JSON ---
  public static StripeWebhookSubscriptionWrapper parse(String json) {
    return (StripeWebhookSubscriptionWrapper) System.JSON.deserialize(
      json,
      StripeWebhookSubscriptionWrapper.class
    );
  }

  // --- Replaces reserved keywords so it matches our Apex wrapper.
  public static String normalizeJson(String jsonInput) {
    if (String.isBlank(jsonInput)) {
      return jsonInput;
    }

    String result = jsonInput
      .replaceAll('"currency":', '"currency_x":')
      .replaceAll('"object":', '"object_x":');

    return result;
  }
  // Service method to handle parsing
  public static StripeWebhookSubscriptionWrapper parseWebhookBody() {
    String rawJson = RestContext.request.requestBody.toString();
    String normalizedJson = StripeWebhookSubscriptionWrapper.normalizeJson(
      rawJson
    );
    return StripeWebhookSubscriptionWrapper.parse(normalizedJson);
  }
}
