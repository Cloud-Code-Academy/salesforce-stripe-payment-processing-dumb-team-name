/**
 * @description Wrapper classes for inbound customer events from Stripe
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Stripe Inbound Integration
 */

public with sharing class StripeWebhookCustomerWrapper {
  public String id { get; set; }
  public String object_x { get; set; }
  public String type { get; set; }
  public DataWrapper data { get; set; }

  public class DataWrapper {
    public CustomerWrapper object_x { get; set; }
  }

  public class CustomerWrapper {
    public String id { get; set; }
    public String object_x { get; set; }
    public String default_source { get; set; }
    public String email { get; set; }
    public String name { get; set; }
    public String phone { get; set; }
  }

  /**
   * @description Helper class for parsing the request body from customer events
   *
   * @return StripeWebhookCustomerWrapper
   */
  public static StripeWebhookCustomerWrapper parse(String body) {
    StripeWebhookCustomerWrapper wrapper = (StripeWebhookCustomerWrapper) JSON.deserialize(
      body,
      StripeWebhookCustomerWrapper.class
    );
    return wrapper;
  }
}
