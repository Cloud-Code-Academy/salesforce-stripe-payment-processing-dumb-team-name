public with sharing class StripeWebhookPaymentIntentWrapper {
  public String id { get; set; }
  public String object_x { get; set; }
  public Long created { get; set; }
  public DataWrapper data { get; set; }
  public String type { get; set; }

  public class DataWrapper {
    public PaymentIntentWrapper object_x { get; set; }
  }

  public class PaymentIntentWrapper {
    public String id { get; set; }
    public Integer amount { get; set; }
    public Long created { get; set; }
    public String currency_x { get; set; }
    public String customer { get; set; }
    public LastPaymentError last_payment_error { get; set; }
    public MetadataWrapper metadata { get; set; }
  }

  public class LastPaymentError {
    public String charge { get; set; }
    public String code { get; set; }
  }

  public class MetadataWrapper {
    public String Salesforce_Subscription_Id { get; set; }
  }

  /**
   * @description Helper method for parsing the request body from an payment intent event
   *
   * @return StripeWebhookPaymentIntentWrapper
   */
  public static StripeWebhookPaymentIntentWrapper parse(String body) {
    StripeWebhookPaymentIntentWrapper wrapper = (StripeWebhookPaymentIntentWrapper) JSON.deserialize(
      body,
      StripeWebhookPaymentIntentWrapper.class
    );
    return wrapper;
  }
}
