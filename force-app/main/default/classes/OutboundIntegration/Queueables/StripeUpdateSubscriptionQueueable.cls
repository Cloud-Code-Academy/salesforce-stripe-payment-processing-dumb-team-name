public with sharing class StripeUpdateSubscriptionQueueable implements Queueable, Database.AllowsCallouts {
  private Map<Id, Stripe_Subscription__c> newSubscriptionsMap;
  private Map<Id, Stripe_Subscription__c> oldSubscriptionsMap;

  public StripeUpdateSubscriptionQueueable(
    Map<Id, Stripe_Subscription__c> newSubscriptionsMap,
    Map<Id, Stripe_Subscription__c> oldSubscriptionsMap
  ) {
    this.newSubscriptionsMap = newSubscriptionsMap;
    this.oldSubscriptionsMap = oldSubscriptionsMap;
  }

  public void execute(QueueableContext qc) {
    System.debug(
      'StripeUpdateSubscriptionQueueable running for subscriptions: ' +
      newSubscriptionsMap.keySet()
    );

    List<Stripe_Subscription__c> subscriptionsToUpdate = new List<Stripe_Subscription__c>();

    List<Stripe_Subscription__c> newSubsList = [
      SELECT
        Id,
        Stripe_Price_ID__c,
        Stripe_Customer__c,
        Stripe_Customer__r.Stripe_Customer_ID__c,
        Stripe_Checkout_Session_Id__c,
        Stripe_Customer__r.Customer_Email__c,
        Sync_Status__c,
        Current_Period_Start__c,
        Current_Period_End__c,
        Status__c,
        Product_Plan_Name__c,
        Stripe_Subscription_ID__c,
        Stripe_Subscription_Item_ID__c
      FROM Stripe_Subscription__c
      WHERE Id IN :newSubscriptionsMap.keySet()
    ];

    for (Stripe_Subscription__c newSub : newSubsList) {
      Stripe_Subscription__c oldSub = oldSubscriptionsMap.get(newSub.Id);

      Boolean isCancelled =
        oldSub.Status__c != 'Canceled' &&
        newSub.Status__c == 'Canceled';
      Boolean productChanged =
        oldSub.Product_Plan_Name__c != newSub.Product_Plan_Name__c;

      System.debug(
        'Processing subscription ' +
          newSub.Id +
          ' | Cancelled? ' +
          isCancelled +
          ' | ProductChanged? ' +
          productChanged
      );

      if (!isCancelled && !productChanged) {
        continue;
      }

      Map<String, String> metadata = new Map<String, String>();
      metadata.put('Subscription_Id', String.valueOf(newSub.Id));
      //metadata.put('Queueable_Job_Id', String.valueOf(System.enqueueJob(this)));

      StripeSubscriptionRequestWrapper requestWrapper = new StripeSubscriptionRequestWrapper(
        newSub.Stripe_Subscription_ID__c,
        newSub.Stripe_Subscription_Item_ID__c,
        newSub.Stripe_Price_ID__c,
        isCancelled,
        //added create prorations. This will push the remaining balance on Stripe to the end of the period.
        productChanged ? 'create_prorations' : null,
        metadata
      );

      HttpRequest req = new HttpRequest();
      req.setEndpoint(
        'callout:STRIPE_NAMED_CREDENTIAL' +
          '/v1/subscriptions/' +
          newSub.Stripe_Subscription_ID__c
      );
      req.setMethod('POST');
      req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
      req.setBody(requestWrapper.toFormEncoded());

      Http http = new Http();

      try {
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
          newSub.Sync_Status__c = 'Synced';
          subscriptionsToUpdate.add(newSub);
        } else {
          Logger.error(
            'Stripe failed to update Subscription ' +
              newSub.Id +
              ' : ' +
              res.getBody()
          );
          Logger.saveLog();
        }
      } catch (Exception e) {
        Logger.error(
          'Stripe update exception for ' + newSub.Id + ' : ' + e.getMessage()
        );
        Logger.saveLog();
      }
    }
    if (!subscriptionsToUpdate.isEmpty()) {
      update subscriptionsToUpdate;
    }
  }
}
