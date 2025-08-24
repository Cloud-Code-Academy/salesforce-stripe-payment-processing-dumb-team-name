public class StripeWebhookSubscriptionWrapper {
  public String id { get; set; }
  public String type { get; set; }
  public Long created { get; set; }
  public DataWrapper data { get; set; }

  public class DataWrapper {
    public SubscriptionWrapper object_x { get; set; }
  }

  public class SubscriptionWrapper {
    public String id { get; set; }
    public String object_x { get; set; }
    public SubscriptionItemsWrapper items { get; set; }
  }

  public class SubscriptionItemsWrapper {
    public String object_x { get; set; } //list
    public List<SubscriptionItemWrapper> data { get; set; }
  }

  public class SubscriptionItemWrapper {
    public String id { get; set; }
    public String object_x { get; set; }
    public Integer current_period_end { get; set; }
    public Integer current_period_start { get; set; }
    public Integer quantity { get; set; }
    public PlanWrapper plan { get; set; }
    public PriceWrapper price { get; set; }
  }
  public class PlanWrapper {
    public String id { get; set; }
    public String object_x { get; set; } // "plan"
    public Boolean active { get; set; }
    public Integer amount { get; set; }
    public String amount_decimal { get; set; }
    public String billing_scheme { get; set; }
    public Long created { get; set; }
    public String currency_x { get; set; }
    public String interval { get; set; }
    public Integer interval_count { get; set; }
    public Boolean livemode { get; set; }
    public Map<String, Object> metadata { get; set; }
    public Object meter { get; set; }
    public String nickname { get; set; }
    public String product { get; set; }
    public Object tiers_mode { get; set; }
    public Object transform_usage { get; set; }
    public Object trial_period_days { get; set; }
    public String usage_type { get; set; }
  }

  public class PriceWrapper {
    public String id { get; set; }
    public String object_x { get; set; } // "price"
    public Boolean active { get; set; }
    public String billing_scheme { get; set; }
    public Long created { get; set; }
    public String currency_x { get; set; }
    public Object custom_unit_amount { get; set; }
    public Boolean livemode { get; set; }
    public String lookup_key { get; set; }
    public Map<String, Object> metadata { get; set; }
    public String nickname { get; set; }
    public String product { get; set; }
    public Recurring recurring { get; set; }
  }

  public class Recurring {
    public String interval { get; set; }
    public Integer interval_count { get; set; }
    public Object meter { get; set; }
    public Object trial_period_days { get; set; }
    public String usage_type { get; set; }
  }

  public static StripeWebhookSubscriptionWrapper parse(String body) {
    StripeWebhookSubscriptionWrapper wrapper = (StripeWebhookSubscriptionWrapper) JSON.deserialize(
      body,
      StripeWebhookSubscriptionWrapper.class
    );
    return wrapper;
  }
}
