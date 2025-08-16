public with sharing class StripeSubscriptionService {

   public static void handleNewSubscriptions(Map<Id, Stripe_Subscri> newSubscriptionMap) {
          if (newSubscriptionMap == null || newSubscriptionMap.isEmpty()) {
               return;
          }
          System.enqueueJob(new StripeSubscriptionQueueable(newSubscriptionMap));
     }
    }