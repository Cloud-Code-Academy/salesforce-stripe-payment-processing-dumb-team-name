public with sharing class StripeCustomerService {
  public static void handleUpdateStripeCustomers(
    Map<Id, Stripe_Customer__c> oldStripeCustomersMap,
    Map<Id, Stripe_Customer__c> newStripeCustomersMap
  ) {
    if (newStripeCustomersMap == null || newStripeCustomersMap.isEmpty()) {
      return;
    }

    Map<Id, Stripe_Customer__c> updateStripeCustomersMap = new Map<Id, Stripe_Customer__c>();

    for (Id custId : newStripeCustomersMap.keySet()) {
      Stripe_Customer__c newRec = newStripeCustomersMap.get(custId);
      Stripe_Customer__c oldRec = oldStripeCustomersMap.get(custId);

      if (hasSyncableFieldsChanged(newRec, oldRec)) {
        updateStripeCustomersMap.put(custId, newRec);
      }
    }

    if (!updateStripeCustomersMap.isEmpty()) {
      System.enqueueJob(
        new StripeUpdateCustomerQueueable(updateStripeCustomersMap)
      );
    }
  }

  private static Boolean hasSyncableFieldsChanged(
    Stripe_Customer__c newRec,
    Stripe_Customer__c oldRec
  ) {
    return newRec.Customer_Name__c != oldRec.Customer_Name__c ||
      newRec.Customer_Email__c != oldRec.Customer_Email__c ||
      newRec.Customer_Phone__c != oldRec.Customer_Phone__c;
  }
}
