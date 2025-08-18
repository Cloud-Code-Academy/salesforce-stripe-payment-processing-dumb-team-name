public with sharing class StripeWebhookSubscriptionWrapper {

    //TODO: transform reserve word currency before sending to the wrappers

    public String id;                         // Stripe Subscription ID
    public String status;                     // Status
    public String currency_x;                 // Currency (usd, etc.)
    public Long created;                      // Created timestamp (epoch seconds)
    public Items items;                       // Items array (to get Price, Plan, Amount, etc.)
    public Long current_period_start;         // Current Period Start
    public Long current_period_end;           // Current Period End
    public String customer;                   // Stripe Customer ID
    public Map<String,Object> metadata;       // Could include Checkout URL, Checkout Session ID, etc.

    public class Items {

        public List<SubscriptionItem> data;
    
    }

    public class SubscriptionItem {
    
        public String id;
        public Plan plan; 
        public Price price;
        public Integer quantity;
    
    }

    public class Plan {
    
        public String id;
        public String nickname;               // Product/Plan Name
        public Integer amount;                // Amount in cents
        public String currency_x;               // Currency
    
    }

    public class Price {
    
        public String id;
        public Integer unit_amount;           // Amount in cents
        public String currency_x;
    
    }

}