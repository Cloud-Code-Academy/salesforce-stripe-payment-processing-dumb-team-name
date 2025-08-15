/**
 * @description - Service layer for contacts. Handle business logic and dml
 * @author - Jonathan Lyles
 * @date - August 13, 2025
 */
public with sharing class ContactService {

     public static Boolean isRunning = false;

     public static void contactsToStripeCustomersSync(Map<Id, Contact> newContactMap) {

          if (newContactMap == null || newContactMap.isEmpty()) {
               return;
          }
          if(!isRunning){
               isRunning = true;
               System.enqueueJob(new ContactStripeSyncQueueable(newContactMap));
          }
     }

     public static void StripeCustomerInsertToContactSync(Map<Id, Stripe_Customer__c> newStripeCustomerMap){
          
          Map<Id, String> contactIdStripeCustomerIdMap = new Map<Id, String>();
          
          for(Stripe_Customer__c stripeCustomer : newStripeCustomerMap.values()){
               contactIdStripeCustomerIdMap.put(stripeCustomer.Contact__c, stripeCustomer.Stripe_Customer_ID__c);
          }

          List<Contact> contactsToSync = [SELECT Id, Stripe_Customer_ID__c FROM Contact WHERE Id IN :contactIdStripeCustomerIdMap.keySet()];
          List<Contact> contactUpdateList = new List<Contact>();

          for(Contact c : contactsToSync){
               c.Stripe_Customer_ID__c = contactIdStripeCustomerIdMap.get(c.Id);
               contactUpdateList.add(c);
          }

          if(contactUpdateList != null){
               update contactUpdateList;
          }
     }
}