public with sharing class StripeSubscriptionService {

   public static void handleNewSubscriptions(Map<Id, Stripe_Subscription__c> newSubscriptionMap) {
          if (newSubscriptionMap == null || newSubscriptionMap.isEmpty()) {
               return;
          }
          System.enqueueJob(new StripeCheckoutQueueable(newSubscriptionMap));
     }
    }