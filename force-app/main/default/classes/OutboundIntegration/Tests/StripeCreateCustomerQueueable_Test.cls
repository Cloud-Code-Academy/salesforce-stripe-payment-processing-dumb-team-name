@IsTest
private class StripeCreateCustomerQueueable_Test {
    /**
     * Testing library/framework in use:
     * - Native Salesforce Apex testing framework with @IsTest annotations,
     *   Test.startTest()/Test.stopTest(), System.assert* assertions, and HttpCalloutMock for callout mocking.
     */

    // Utility to build a standard Contact map for input
    private static Map<Id, Contact> createContactsMap(Integer howMany) {
        List<Contact> toInsert = new List<Contact>();
        String uniqueSuffix = String.valueOf(Crypto.getRandomInteger()) + Datetime.now().getTime();
        for (Integer i = 0; i < howMany; i++) {
            toInsert.add(new Contact(
                FirstName = 'First' + i,
                LastName = 'Last' + i,
                Email = 'user' + i + '_'+ uniqueSuffix + '@example.com'
            ));
        }
        insert toInsert;
        Map<Id, Contact> m = new Map<Id, Contact>();
        for (Contact c : toInsert) {
            m.put(c.Id, c);
        }
        return m;
    }

    // Success mock returning a 200 with JSON body matching StripeAPIResponseWrappers expectations
private class SuccessCustomerCreateMock implements HttpCalloutMock {
    private List<Id> contactIds;
    private Integer index = 0;

    SuccessCustomerCreateMock(Set<Id> ids) {
        contactIds = new List<Id>(ids);
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');

        String cId = contactIds[index];
        index++;

        res.setBody('{"id":"cus_test_' + cId + '","email":"synced@example.com","name":"Synced Name"}');
        return res;
    }
}


    // Non-success mock returning a 400 response
    private class ErrorCustomerCreateMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            res.setStatus('Bad Request');
            res.setBody('{"error":{"message":"Invalid request"}}');
            return res;
        }
    }

    // Exception mock to simulate an exception during callout
    private class ExceptionCustomerCreateMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Simulate an unexpected failure inside the callout
            // This will be caught by the try-catch in the Queueable.execute
            throw new CalloutException('Simulated callout failure');
        }
    }

    @IsTest
    static void test_singleContact_success_createsStripeCustomerAndUpdatesContact() {
        Map<Id, Contact> contactMap = createContactsMap(1);
        Id cId = contactMap.keySet().iterator().next();

        Test.setMock(HttpCalloutMock.class, new SuccessCustomerCreateMock(new Set<Id>{ cId }));

        Test.startTest();
        System.enqueueJob(new ContactStripeSyncQueueable(contactMap));
        Test.stopTest();

        // After job runs: Contact should have Stripe_Customer_ID__c set, and a Stripe_Customer__c record inserted
        Contact updated = [SELECT Id, Stripe_Customer_ID__c, Email, FirstName, LastName FROM Contact WHERE Id = :cId];
        System.assertNotEquals(null, updated.Stripe_Customer_ID__c, 'Stripe ID should not be null');

        // Verify Stripe_Customer__c was inserted with expected fields
        Stripe_Customer__c sc = [
            SELECT Id, Contact__c, Customer_Email__c, Customer_Name__c, Stripe_Customer_ID__c
            FROM Stripe_Customer__c WHERE Contact__c = :cId LIMIT 1
        ];
        System.assertEquals(updated.Id, sc.Contact__c, 'Stripe_Customer__c must reference Contact');
        System.assertNotEquals(null, sc.Stripe_Customer_ID__c, 'Stripe ID should not be null');
        System.assertNotEquals(null, sc.Customer_Email__c, 'Email copied from response should not be null');
        System.assertNotEquals(null, sc.Customer_Name__c, 'Name copied from response should not be null');
    }

    @IsTest
    static void test_multipleContacts_success_allContactsUpdated() {
        // Create multiple contacts
        Map<Id, Contact> contactMap = createContactsMap(3);
        Set<Id> ids = new Set<Id>(contactMap.keySet());

        Test.setMock(HttpCalloutMock.class, new SuccessCustomerCreateMock(ids));

        Test.startTest();
        System.enqueueJob(new ContactStripeSyncQueueable(contactMap));
        Test.stopTest();

        // Verify all contacts updated and Stripe_Customer__c records created
        List<Contact> updated = [SELECT Id, Stripe_Customer_ID__c FROM Contact WHERE Id IN :ids ORDER BY Id];
        System.assertEquals(3, updated.size(), 'Expect 3 updated contacts');
        for (Contact c : updated) {
           System.assertNotEquals(null, c.Stripe_Customer_ID__c, 'Contact should have a Stripe Customer ID assigned');
        }

        Integer stripeRecords = [SELECT COUNT() FROM Stripe_Customer__c WHERE Contact__c IN :ids];
        System.assertEquals(3, stripeRecords, 'One Stripe_Customer__c per contact should be created');
    }

    @IsTest
    static void test_nonSuccessResponse_noUpdatesNoInserts() {
        Map<Id, Contact> contactMap = createContactsMap(1);
        Id cId = contactMap.keySet().iterator().next();

        Test.setMock(HttpCalloutMock.class, new ErrorCustomerCreateMock());

        Test.startTest();
        System.enqueueJob(new ContactStripeSyncQueueable(contactMap));
        Test.stopTest();

        // Verify contact not updated
        Contact after = [SELECT Id, Stripe_Customer_ID__c FROM Contact WHERE Id = :cId];
        System.assertEquals(null, after.Stripe_Customer_ID__c, 'Contact should not be updated on non-200 status');

        // Verify no Stripe_Customer__c inserted
        System.assertEquals(0, [SELECT COUNT() FROM Stripe_Customer__c WHERE Contact__c = :cId], 'No Stripe_Customer__c should be created on failure');
    }

    @IsTest
    static void test_exceptionDuringCallout_isCaught_noDmlAndNoUncaughtErrors() {
        Map<Id, Contact> contactMap = createContactsMap(1);
        Id cId = contactMap.keySet().iterator().next();

        Test.setMock(HttpCalloutMock.class, new ExceptionCustomerCreateMock());

        Test.startTest();
        // Should not throw, since implementation catches Exception
        System.enqueueJob(new ContactStripeSyncQueueable(contactMap));
        Test.stopTest();

        // Verify no updates or inserts
        Contact after = [SELECT Id, Stripe_Customer_ID__c FROM Contact WHERE Id = :cId];
        System.assertEquals(null, after.Stripe_Customer_ID__c, 'Contact should remain unchanged when an exception occurs');
        System.assertEquals(0, [SELECT COUNT() FROM Stripe_Customer__c WHERE Contact__c = :cId], 'No Stripe_Customer__c on exception');
    }

    @IsTest
    static void test_emptyInputMap_noWorkNoErrors() {
        Map<Id, Contact> empty = new Map<Id, Contact>();

        // Even with an empty map, the queueable should run and not perform DML/callouts.
        // Use a success mock just in case, but expect no calls since no contacts are queried.
        Test.setMock(HttpCalloutMock.class, new SuccessCustomerCreateMock(new Set<Id>()));

        Test.startTest();
        System.enqueueJob(new ContactStripeSyncQueueable(empty));
        Test.stopTest();

        // Nothing to assert on data; main assertion is no exception thrown and no stray Stripe_Customer__c
        System.assertEquals(0, [SELECT COUNT() FROM Stripe_Customer__c], 'No Stripe records should exist with empty input');
    }
}