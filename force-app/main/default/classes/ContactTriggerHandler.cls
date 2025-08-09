public with sharing class ContactTriggerHandler extends TriggerHandler {

    private Map<Id, Contact> newContactMap;

    public ContactTriggerHandler() {
        this.newContactMap = (Map<Id, Contact>) Trigger.newMap;
        this.setMaxLoopCount(1);
    }
    
    public override void afterInsert(){
        if(newContactMap.isEmpty()){
            //Throw an exception and log it
        }else{
            ContactService.handleNewContacts((List<Contact>) newContactMap.values());
        }
    }
}