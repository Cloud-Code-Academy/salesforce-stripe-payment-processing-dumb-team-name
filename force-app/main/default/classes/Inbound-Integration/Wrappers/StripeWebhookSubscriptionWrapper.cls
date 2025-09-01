/**
 * @description Wrapper classes for inbound Stripe subscription events
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Stripe Inbound Integration
 *
 */

public class StripeWebhookSubscriptionWrapper {
  public String id { get; set; }
  public String object_x { get; set; }
  public Long created { get; set; }
  public DataWrapper data { get; set; }
  public String type { get; set; }

  public class DataWrapper {
    public SubscriptionWrapper object_x { get; set; }
  }

  public class SubscriptionWrapper {
    public String id { get; set; }
    public String currency_x { get; set; }
    public String customer { get; set; }
    public String default_source { get; set; }
    public SubscriptionItemsWrapper items { get; set; }
    public MetadataWrapper metadata { get; set; }
  }

  public class SubscriptionItemsWrapper {
    public List<InnerDataWrapper> data { get; set; }
  }

  public class InnerDataWrapper {
    public String id { get; set; }
    public Long current_period_end { get; set; }
    public Long current_period_start { get; set; }
    public PlanWrapper plan { get; set; }
    public PriceWrapper price { get; set; }
    public Integer quantity { get; set; }
    public String subscription { get; set; }
  }

  public class MetadataWrapper {
    public String Salesforce_Subscription_Id { get; set; }
  }

  // public class StripeWebhookSubscriptionWrapper {
  //   public String id { get; set; }
  //   public String type { get; set; }
  //   public Long created { get; set; }
  //   public DataWrapper data { get; set; }
  //   // public String currency_x { get; set; }
  //   // public String customer { get; set; }

  //   public class DataWrapper {
  //     public SubscriptionWrapper object_x { get; set; }
  //   }

  //   public class SubscriptionWrapper {
  //     public String id { get; set; } // Stripe Subscription Id, example: sub_1S08Lj4hwnEBsWxgxxStKHLh
  //     public String object_x { get; set; } // subscription
  //     public SubscriptionItemsWrapper items { get; set; }
  //     public MetadataWrapper metadata { get; set; }
  //     public String currency_x { get; set; }
  //     public String customer { get; set; }
  //     public String default_source { get; set; }
  //   }

  //   public class SubscriptionItemsWrapper {
  //     public String object_x { get; set; }
  //     public List<SubscriptionItemWrapper> data { get; set; }
  //   }

  //   public class SubscriptionItemWrapper {
  //     public String id { get; set; }
  //     public String object_x { get; set; }
  //     public Long current_period_end { get; set; }
  //     public Long current_period_start { get; set; }
  //     public Integer quantity { get; set; }
  //     public PlanWrapper plan { get; set; }
  //     public PriceWrapper price { get; set; }
  //   }
  public class PlanWrapper {
    public String id { get; set; }
    public String object_x { get; set; } // "plan"
    public Boolean active { get; set; }
    public Integer amount { get; set; }
    public String currency_x { get; set; }
    public Integer amount_decimal { get; set; }
    public String billing_scheme { get; set; }

    public String product { get; set; }
  }

  public class PriceWrapper {
    public String id { get; set; }
    public String object_x { get; set; } // "price"
    public Boolean active { get; set; }

    public String currency_x { get; set; }

    public String product { get; set; }
  }

  //   public class MetadataWrapper {
  //     public String Salesforce_Subscription_Id { get; set; }
  //   }

  /**
   * @description Helper class for parsing request bodies from subscription events
   *
   * @return StripeWebhookSubscriptionWrapper
   */
  public static StripeWebhookSubscriptionWrapper parse(String body) {
    StripeWebhookSubscriptionWrapper wrapper = (StripeWebhookSubscriptionWrapper) JSON.deserialize(
      body,
      StripeWebhookSubscriptionWrapper.class
    );
    return wrapper;
  }
}
