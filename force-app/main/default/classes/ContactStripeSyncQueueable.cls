public with sharing class ContactStripeSyncQueueable implements Queueable, Database.AllowsCallouts{

    private Map<Id, Contact> contactsToSyncMap;

    public ContactStripeSyncQueueable(Map<Id, Contact> contactsToSyncMap){
        this.contactsToSyncMap = contactsToSyncMap;
    }

    public void execute(QueueableContext qc){
           
    }
}