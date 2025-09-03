public with sharing class StripeCheckoutResponseWrapper {
  public String id; // The Checkout Session ID (cs_test_...)
  public String objectType; // "checkout.session"
  public String mode; // "subscription"
  public String customer; // Customer ID (cus_...)
  public String subscription; // Will be null until checkout completes
  public String status; // "open", "complete", "expired"
  public String success_url; // URL you passed in
  public String cancel_url; // URL you passed in

  public String url;

  public Map<String, String> metadata;

  // public class SubscriptionItems {
  //     public String object;
  //     public List<SubscriptionItem> data;
  //  }
  //  public class SubscriptionItem {
  //     public String id;
  //     public String object;
  //     public Price price;
  //     public Integer quantity;
  //  }

  //  public class Price {
  //     public String id;
  //     public String product;
  //  }
}
