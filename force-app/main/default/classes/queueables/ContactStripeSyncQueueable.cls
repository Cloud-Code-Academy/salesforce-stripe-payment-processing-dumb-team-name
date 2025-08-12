public with sharing class ContactStripeSyncQueueable implements Queueable, Database.AllowsCallouts{

    private IStripeClient stripeClient;

    private Map<Id, Contact> contactsToSyncMap;

    public ContactStripeSyncQueueable(Map<Id, Contact> contactsToSyncMap){
        this.contactsToSyncMap = contactsToSyncMap;
    }

    // For tests, inject the mock
    public ContactStripeSyncQueueable(Map<Id, Contact> contactsToSyncMap, IStripeClient stripeClient) {
        this.contactsToSyncMap = contactsToSyncMap;
        this.stripeClient = stripeClient;
    }

    public void execute(QueueableContext qc){

        List<Contact> contacts = ContactRepository.getContactsByIds(contactsToSyncMap.keySet());
        List<Contact> contactsToUpdate =  new List<Contact>();
        List<Stripe_Customer__c> stripeCustomers = new List<Stripe_Customer__c>();
         
        for(Contact c : contacts){

            StripeAPIRequestWrapper req = new StripeAPIRequestWrapper(
            c.FirstName + ' ' + c.LastName,
            c.Email
            );
            String body = req.toUrlEncodedString();
            
            HttpResponse res = StripeClient.doPost('/v1/customers', body);
    
            StripeCustomerDTO stripeResponse = StripeAPIResponseWrappers.parse(res.getBody());

            c.Stripe_Customer_ID__c = stripeResponse.id;
            contactsToUpdate.add(c);

            Stripe_Customer__c newStripeCust = StripeService.newStripeCustomer(c.Id, stripeResponse);

            stripeCustomers.add(newStripeCust);
        
        }

        if(!contactsToUpdate.isEmpty()){
            ContactService.updateContacts(contactsToUpdate);
        }

        if(!stripeCustomers.isEmpty()){
            StripeService.insertNewStripeCustomers(stripeCustomers);
    }
        Logger.saveLog();
    }
}