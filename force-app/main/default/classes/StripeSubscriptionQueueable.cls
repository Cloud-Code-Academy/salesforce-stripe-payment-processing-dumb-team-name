public with sharing class StripeSubscriptionQueueable implements Queueable, Database.AllowsCallouts{
        private Map<Id, Stripe_Subscription__c> newSubscriptionsMap;

    public StripeSubscriptionStripeQueueable(Map<Id, Stripe_Subscription__c> newSubscriptionsMap){
        this.newSubscriptionsMap = newSubscriptionsMap;
    }

    public void execute(QueueableContext qc){

        List<Stripe_Subscription__c> subscriptionsToInsert = new List<Stripe_Subscription__c>();

        for(Stripe_Subscription__c sub : newSubscriptionsMap.values()){
            StripeSubscriptionRequestWrapper requestWrapper = new StripeSubscriptionRequestWrapper(sub.Currency__c, sub.PriceId__c, sub.Recurring_Interval__c, sub.Unit_Amount__c, sub.CustomerId__c);

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:STRIPE_NAMED_CREDENTIAL'+'/v1/subscriptions');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setBody(requestWrapper.toUrlEncodedString());

            Http http = new Http();
            HttpResponse res = http.send(req);
            try {
                res = http.send(req);
            } catch(Exception e) {
                Logger.error('Stripe Subscription callout failed for subscription ' + sub.Id + ': '+e.getMessage());
                Logger.saveLog();
                continue;
            }
            System.debug(res.getBody());


        //need to check if default payment method is populated or not
        //if not...default it to something??
}
}