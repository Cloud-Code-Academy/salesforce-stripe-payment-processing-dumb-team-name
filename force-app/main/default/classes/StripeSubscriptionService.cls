public with sharing class StripeSubscriptionService {

   public static void handleNewSubscriptions(Map<Id, Stripe_Subscription__c> newSubscriptionsMap) {
          if (newSubscriptionsMap == null || newSubscriptionsMap.isEmpty()) {
               return;
          }
          System.enqueueJob(new StripeCheckoutQueueable(newSubscriptionsMap));
     }

     public static void handleUpdatedSubscriptions(Map<Id, Stripe_Subscription__c> newSubscriptionsMap, Map<Id, Stripe_Subscription__c> oldSubscriptionsMap) {
          System.debug('handleUpdatedSubscriptions called, newSubscriptionsMap: ' + newSubscriptionsMap.keySet());
          if (newSubscriptionsMap == null || newSubscriptionsMap.isEmpty()) {
               return;
          }
          System.enqueueJob(new StripeUpdateSubscriptionQueueable(newSubscriptionsMap, oldSubscriptionsMap));
          System.debug('Enqueued StripeUpdateSubscriptionQueueable');
     }
}
     
    