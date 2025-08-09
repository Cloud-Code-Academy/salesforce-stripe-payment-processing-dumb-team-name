public with sharing class ContactService {
    public static void handleNewContacts(List<Contact> contacts){
        System.enqueueJob(new ContactStripeSyncQueueable(contacts));
    }
}