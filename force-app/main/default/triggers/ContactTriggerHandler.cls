/**
 * @description - Contact trigger logic
 * @author - Jonathan Lyles
 * @date - August 11, 2025
 */
public with sharing class ContactTriggerHandler extends TriggerHandler {

    private Map<Id, Contact> newContactMap;
    //public static Boolean isRunning = false;

    public ContactTriggerHandler() {

        this.newContactMap = (Map<Id, Contact>) Trigger.newMap;
        this.setMaxLoopCount(1);

    }
    
    public override void afterInsert(){

        ContactService.contactsToStripeCustomersSync(newContactMap);  

    }
}