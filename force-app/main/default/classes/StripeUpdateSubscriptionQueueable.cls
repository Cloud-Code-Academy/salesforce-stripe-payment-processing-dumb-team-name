public with sharing class StripeUpdateSubscriptionQueueable implements Queueable, Database.AllowsCallouts {
  private Map<Id, Stripe_Subscription__c> newSubscriptionsMap;

  public StripeUpdateSubscriptionQueueable(
    Map<Id, Stripe_Subscription__c> updateSubscriptionsMap
  ) {
    this.updateSubscriptionsMap = updateSubscriptionsMap;
  }

  public void execute(QueueableContext qc) {
    List<Stripe_Subscription__c> subscriptionsToUpdate = new List<Stripe_Subscription__c>();

    List<Stripe_Subscription__c> subs = [
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
        Status__c
      FROM Stripe_Subscription__c
      WHERE Id IN :updateSubscriptionsMap.keySet()
    ];

    List<Stripe_Subscription__c> subsToUpdate = new List<Stripe_Subscription__c>();

    for (Stripe_Subscription__c sub : subs) {
    }
  }
}
