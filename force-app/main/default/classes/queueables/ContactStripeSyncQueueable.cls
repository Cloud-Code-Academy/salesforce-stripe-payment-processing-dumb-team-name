public with sharing class ContactStripeSyncQueueable implements Queueable, Database.AllowsCallouts{

    private IStripeStrategy strategy;
    public Map<Id, Contact> contactsToSyncMap;

    public ContactStripeSyncQueueable(Map<Id, Contact> contactsToSyncMap){
        this.contactsToSyncMap = contactsToSyncMap.deepClone();
    }

    public void execute(QueueableContext qc){

        List<Contact> contacts = ContactRepository.getContactsByIds(contactsToSyncMap.keySet());
        List<Contact> contactsToUpdate =  new List<Contact>();
        List<Stripe_Customer__c> stripeCustomers = new List<Stripe_Customer__c>();
         
        for(Contact c : contacts){

            String name;
            String email;
            
            try{
                if(c.FirstName == null || c.LastName == null){
                    throw new ContactStripeQueueableException('First and last name values are required to create a Stripe Customer record');
                }else{
                    name = c.FirstName + ' ' + c.LastName;
                    email = c.Email;
                }
            }catch(Exception e){
                Logger.error(e.getMessage());
            }
            
            
            this.strategy = new CreateCustomerStrategy(name, c.email);

            
            StripeAPIClient createClient = new StripeAPIClient(this.strategy);
            
            HttpResponse res = createClient.run();

            StripeAPIResponseWrappers stripeCustomerResponse = StripeAPIResponseWrappers.parse(res.getBody());
            
            Stripe_Customer__c newStripeCustomer = StripeService.newStripeCustomer(c.Id, stripeCustomerResponse);

            stripeCustomers.add(newStripeCustomer);

            contactsToSyncMap.put(c.Id, c);

        }

        if(!contactsToSyncMap.isEmpty()){
            ContactService.handleNewContacts(contactsToSyncMap);
        }

        if(!stripeCustomers.isEmpty()){
            StripeService.insertNewStripeCustomers(stripeCustomers);
        }
        
        Logger.saveLog();
    }

    public class ContactStripeQueueableException extends Exception{}
}