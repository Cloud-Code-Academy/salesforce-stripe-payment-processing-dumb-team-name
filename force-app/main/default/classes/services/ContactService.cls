/**
 * @description - Service layer for contacts. Handle business logic and dml
 * @author - Jonathan Lyles
 * @date - August 13, 2025
 */
public with sharing class ContactService {

     //TODO: Add documentation here
     public static void handleNewContacts(Map<Id, Contact> newContactMap) {
          if (newContactMap == null || newContactMap.isEmpty()) {
               return;
          }
          System.enqueueJob(new ContactStripeSyncQueueable(newContactMap));
     }

     

}