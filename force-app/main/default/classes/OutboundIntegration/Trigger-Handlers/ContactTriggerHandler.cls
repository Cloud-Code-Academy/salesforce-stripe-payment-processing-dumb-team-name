public with sharing class ContactTriggerHandler extends TriggerHandler {

    private Map<Id, Contact> newContactMap;

    public ContactTriggerHandler() {
        this.newContactMap = (Map<Id, Contact>) Trigger.newMap;
        //this.setMaxLoopCount(2);
    }
    
    public override void afterInsert(){
            ContactService.handleNewContacts(newContactMap);
    }
}