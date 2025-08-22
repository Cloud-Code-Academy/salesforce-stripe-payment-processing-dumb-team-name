public with sharing class StripeSubscriptionService {

   public static void handleNewSubscriptions(Map<Id, Stripe_Subscription__c> newSubscriptionMap) {
          if (newSubscriptionMap == null || newSubscriptionMap.isEmpty()) {
               return;
          }
          System.enqueueJob(new StripeCheckoutQueueable(newSubscriptionMap));
     }

     public static void handleUpdatedSubscriptions(Map<Id, Stripe_Subscription__c> updatedSubscriptionMap) {
          if (updatedSubscriptionMap == null || updatedSubscriptionMap.isEmpty()) {
               return;
          }
          System.enqueueJob(new StripeUpdateSubscriptionQueueable(updatedSubscriptionMap));
     }
}
     
    