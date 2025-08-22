public with sharing class StripeCheckoutQueueable implements Queueable, Database.AllowsCallouts {
private Map<Id, Stripe_Subscription__c> newSubscriptionsMap;

    public StripeCheckoutQueueable(Map<Id, Stripe_Subscription__c> newSubscriptionsMap){
        this.newSubscriptionsMap = newSubscriptionsMap;
    }

    public void execute(QueueableContext qc){

        List<Stripe_Subscription__c> subscriptionsToUpdate = new List<Stripe_Subscription__c>();

        List<Stripe_Subscription__c> subs = [
            SELECT Id,
                   Stripe_Price_ID__c,
                   Stripe_Customer__c,
                   Stripe_Customer__r.Stripe_Customer_ID__c,
                   Stripe_Checkout_Session_Id__c,
                   Stripe_Customer__r.Customer_Email__c,
                   Sync_Status__c
            FROM Stripe_Subscription__c
            WHERE Id IN :newSubscriptionsMap.keySet()
        ];

            for(Stripe_Subscription__c sub : subs){
            // Get the actual Stripe Customer ID from the related record
            String stripeCustomerId = sub.Stripe_Customer__r?.Stripe_Customer_ID__c;
            if(String.isBlank(stripeCustomerId)) {
                Logger.error('Missing Stripe Customer ID for subscription ' + sub.Id);
                Logger.saveLog();
                continue; // skip this subscription
            }

        //for(Stripe_Subscription__c sub : newSubscriptionsMap.values()){
            List<StripeCheckoutRequestWrapper.LineItem> lineItems = new List<StripeCheckoutRequestWrapper.LineItem>();
            lineItems.add(new StripeCheckoutRequestWrapper.LineItem(sub.Stripe_Price_ID__c, 1));

            Map<String,String> metadata = new Map<String,String>();
            Map<String,String> subscriptionMetadata = new Map<String,String>();

            StripeCheckoutRequestWrapper requestWrapper = new StripeCheckoutRequestWrapper(
                stripeCustomerId,
                'subscription',
                'http://www.google.com',
                'http://wwww.yahoo.com',
                lineItems,
                metadata,
                String.valueOf(sub.Id),
                subscriptionMetadata
            );



            String payload = requestWrapper.toFormEncoded();

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:STRIPE_NAMED_CREDENTIAL'+'/v1/checkout/sessions');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setBody(payload);

            Http http = new Http();
            HttpResponse res;
            try {
                res = http.send(req);
                System.debug(res.getBody());
                if(res.getStatusCode() == 200) {
                    StripeCheckoutResponseWrapper responseWrapper = (StripeCheckoutResponseWrapper)JSON.deserialize(res.getBody(), StripeCheckoutResponseWrapper.class);

                    sub.Stripe_Subscription_ID__c = responseWrapper.subscription;
                    sub.Stripe_Checkout_Session_Id__c = responseWrapper.id;
                    sub.Checkout_URL__c = responseWrapper.url;
                    sub.Sync_Status__c = 'Checkout Created';
                    subscriptionsToUpdate.add(sub);
                    StripeEmailService.sendCheckoutSessionEmail(sub, responseWrapper.url);
                } else {
                    Logger.error('Stripe Subscription callout failed for subscription ' + sub.Id + 
                        ' with status ' + res.getStatusCode() + ': ' + res.getBody());
                    Logger.saveLog();
                }
            } catch(Exception e) {
                Logger.error('Stripe Subscription callout failed for subscription ' + sub.Id + ': '+e.getMessage());
                Logger.saveLog();
                
            }
        }
        
        if(!subscriptionsToUpdate.isEmpty()) {
            update subscriptionsToUpdate;
        }

        
    }
}


        //need to check if default payment method is populated or not
        //if not...default it to something}
