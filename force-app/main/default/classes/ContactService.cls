public with sharing class ContactService {
    public static void handleNewContacts(Map<Id,Contact> newContactMap){
        System.enqueueJob(new ContactStripeSyncQueueable(newContactMap));
    }
}