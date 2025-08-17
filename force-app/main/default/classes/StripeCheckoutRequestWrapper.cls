public with sharing class StripeCheckoutRequestWrapper {
        public List<LineItem> lineItems = new List<LineItem>();
        public Map<String, String> metadata = new Map<String, String>();
        public String customer;
        public String mode;
        public String success_url;
        public String cancel_url;

    public StripeCheckoutRequestWrapper(
        String customer,
        String mode,
        String successUrl,
        String cancelUrl,
        List<LineItem> lineItems,
        Map<String, String> metadata,
        String subscriptioId
    ) {
        this.customer = customer;
        this.mode = mode;
        this.success_url = successUrl;
        this.cancel_url = cancelUrl;
        this.lineItems = lineItems;
        if(metadata == null) {
            metadata = new Map<String,String>();
        }
        metadata.put('Salesforce_Subscription_Id', subscriptioId);       
        this.metadata = metadata;
    }

    public class LineItem {
        public String price;
        public Integer quantity;

        public LineItem(String price, Integer quantity) {
            if(String.isBlank(price)) {
                Logger.error('Missing Stripe Price. Cannot continue with transaction.');
                Logger.saveLog();
            }
            if(quantity == null) {
                Logger.error('Missing Quantity. Cannot continue with transaction.');
                Logger.saveLog();
            }            
            this.price = price;
            this.quantity = quantity;
        }
    }

    public String toFormEncoded() {
        List<String> params = new List<String>();
        
        Map<String, String> fields = new Map<String,String>{
            'customer' => customer,
            'mode' => mode,
            'cancel_url' => cancel_url,
            'success_url' => success_url
        };

        for(String key : fields.keySet()) {
            String value = fields.get(key);
            if(String.isNotBlank(value)) {
                params.add(key + '=' + EncodingUtil.urlEncode(value, 'UTF-8'));
            }
        }
        for(Integer i = 0; i < lineItems.size(); i++) {
            LineItem li = lineItems[i];
            params.add('line_items[' + i + '][price]=' + EncodingUtil.urlEncode(li.price,'UTF-8'));
            params.add('line_items[' + i + '][quantity]=' + EncodingUtil.urlEncode(String.valueOf(li.quantity),'UTF-8'));
        }
        for(String key : metadata.keySet()) {
            String value = metadata.get(key);
            if(!String.isBlank(key) && !String.isBlank(value)) {
                params.add('metadata[' + EncodingUtil.urlEncode(key,'UTF-8') + ']=' + EncodingUtil.urlEncode(value,'UTF-8'));
            }
        }
        return String.join(params,'&');
    }
}

