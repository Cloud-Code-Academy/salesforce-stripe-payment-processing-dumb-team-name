@IsTest
public with sharing class ContactTriggerTest {
    @IsTest
    public static void testContactAfterInsert() {
        // 1. Create the test data
        Contact c = new Contact();
        c.LastName = 'Trigger';
        c.FirstName = 'Test';
        c.Email = 'test@email.com';

        // 2. Set mock class for the callout
        Test.setMock(HttpCalloutMock.class, new StripeAPIMock());

        // 3. Begin the test
        Test.startTest();

        // 4. Insert the test data (this will fire the Contact trigger)
        insert c;
        Test.stopTest();
        
        // 5. Assert that the test worked
        // Query the created Stripe customer record
Stripe_Customer__c sc = [
    SELECT Id, Contact__c, Stripe_Customer_Id__c
    FROM Stripe_Customer__c
    WHERE Contact__c = :c.Id
    LIMIT 1
];

// Assert record creation
System.assertNotEquals(null, sc, 'Stripe Customer record should be created.');

// Assert Contact link
System.assertEquals(c.Id, sc.Contact__c, 'Stripe Customer should be linked to the correct Contact.');

// Assert Stripe customer ID from mock
System.assertEquals('cus_mock123', sc.Stripe_Customer_Id__c, 'Stripe Customer ID should match mock value.');
    
    }
}