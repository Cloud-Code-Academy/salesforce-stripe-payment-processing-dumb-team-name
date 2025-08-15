public with sharing class ContactStripeSyncQueueable implements Queueable, Database.AllowsCallouts{

    public Map<Id, Contact> contactsToSyncMap;

    public ContactStripeSyncQueueable(Map<Id, Contact> contactsToSyncMap){

        this.contactsToSyncMap = contactsToSyncMap.deepClone();

    }

    public void execute(QueueableContext qc){

        List<Stripe_Customer__c> stripeCustomers = new List<Stripe_Customer__c>();
         
        for(Contact c : contactsToSyncMap.values()){

            String name = null;
            String email = null;
            
            try{
                if(c.FirstName == null || c.LastName == null){
                    throw new ContactStripeQueueableException('First and last name values are required to create a Stripe Customer record');
                }else{
                    name = c.FirstName + ' ' + c.LastName;
                    System.debug('The customers name: ' + name);
                }
            }catch(Exception e){
                Logger.error(e.getMessage());
            }

            try{
                if(c.Email == null){
                    throw new ContactStripeQueueableException('Email is a required field');
                }else{
                    email = c.Email;
                }
            }catch(Exception e){
                Logger.error(e.getMessage());
            }
            
            try{

                if(name == null || email == null){
                    throw new ContactStripeQueueableException('Email or Name cannot be null');
                }

                IStripeStrategy strategy = null;

                if(Test.isRunningTest()){
                    strategy = new CreateCustomerStrategyTest();
                }else{
                    strategy = new CreateCustomerStrategy(name, c.email);
                }
                 
                StripeAPIClient createClient = new StripeAPIClient(strategy);
            
                HttpResponse res = createClient.run();
                
                StripeAPIResponseWrappers stripeCustomerResponse = StripeAPIResponseWrappers.parse(res.getBody());
                System.debug(stripeCustomerResponse);
            
                Stripe_Customer__c newStripeCustomer = StripeService.newStripeCustomer(c.Id, stripeCustomerResponse);

                stripeCustomers.add(newStripeCustomer);
                
                }catch(Exception e){
                    Logger.Error(e.getMessage());
                }
        }

        if(!stripeCustomers.isEmpty()){
            StripeService.insertNewStripeCustomers(stripeCustomers);
        }
        
        Logger.saveLog();
    }

    public class ContactStripeQueueableException extends Exception{}
}