public with sharing class ContactService {
  public static void handleNewContacts(Map<Id, Contact> newContactMap) {
    if (newContactMap == null || newContactMap.isEmpty()) {
      return;
    }
    System.enqueueJob(new StripeCreateCustomerQueueable(newContactMap));
  }
}
