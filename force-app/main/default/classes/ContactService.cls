public with sharing class ContactService {
    public static void handleNewContacts(List<Contact> contacts){
        
        //TODO: For now, this isn't checking anything

        List<Contact> contactsToSync = contacts;

        System.enqueueJob(new ContactStripeSyncQueueable(contactsToSync));

    }
}