public with sharing class ContactStripeSyncQueueable implements Queueable, Database.AllowsCallouts{

    private List<Contact> contactsToSync;

    public ContactStripeSyncQueueable(List<Contact> contacts){
        this.contactsToSync = contacts;
    }

    public void execute(QueueableContext qc){
           
    }
}