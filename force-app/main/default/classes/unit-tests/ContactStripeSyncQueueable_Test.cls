@IsTest
private class ContactStripeSyncQueueable_Test {
    /**
     * Testing library/framework in use:
     * - Native Salesforce Apex testing framework with @IsTest annotations,
     *   Test.startTest()/Test.stopTest(), System.assert* assertions, and HttpCalloutMock for callout mocking.
     */

    // Utility to build a standard Contact map for input
    private static Map<Id, Contact> createContactsAndMap(Integer howMany) {
        List<Contact> toInsert = new List<Contact>();
        for (Integer i = 0; i < howMany; i++) {
            toInsert.add(new Contact(
                FirstName = 'First' + i,
                LastName = 'Last' + i,
                Email = 'user' + i + '@example.com'
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
        private Set<Id> expectedIds;
        SuccessCustomerCreateMock(Set<Id> ids) {
            this.expectedIds = ids;
        }
        public HTTPResponse respond(HTTPRequest req) {
            // Validate request basics
            System.assertNotEquals(null, req, 'Request must not be null');
            System.assertEquals('POST', req.getMethod(), 'Method should be POST');
            System.assert(req.getEndpoint().startsWith('callout:STRIPE_NAMED_CREDENTIAL'), 'Endpoint must target Named Credential');
            System.assertEquals('application/x-www-form-urlencoded', req.getHeader('Content-Type'), 'Content-Type must be urlencoded');
            String body = req.getBody();
            System.assertNotEquals(null, body, 'Body should be present');
            System.assert(body.contains('email='), 'Body should include email=');
            System.assert(body.contains('name='), 'Body should include name=');

            // Return a successful Stripe-like response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            // Use static values; the implementation only uses id/email/name
            res.setBody('{"id":"cus_test_123","email":"synced@example.com","name":"Synced Name"}');
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
        Map<Id, Contact> contactMap = createContactsAndMap(1);
        Id cId = contactMap.keySet().iterator().next();

        Test.setMock(HttpCalloutMock.class, new SuccessCustomerCreateMock(new Set<Id>{ cId }));

        Test.startTest();
        System.enqueueJob(new ContactStripeSyncQueueable(contactMap));
        Test.stopTest();

        // After job runs: Contact should have Stripe_Customer_ID__c set, and a Stripe_Customer__c record inserted
        Contact updated = [SELECT Id, Stripe_Customer_ID__c, Email, FirstName, LastName FROM Contact WHERE Id = :cId];
        System.assertEquals('cus_test_123', updated.Stripe_Customer_ID__c, 'Contact should be stamped with Stripe Customer ID');

        // Verify Stripe_Customer__c was inserted with expected fields
        Stripe_Customer__c sc = [
            SELECT Id, Contact__c, Customer_Email__c, Customer_Name__c, Stripe_Customer_ID__c
            FROM Stripe_Customer__c WHERE Contact__c = :cId LIMIT 1
        ];
        System.assertEquals(updated.Id, sc.Contact__c, 'Stripe_Customer__c must reference Contact');
        System.assertEquals('synced@example.com', sc.Customer_Email__c, 'Email copied from response');
        System.assertEquals('Synced Name', sc.Customer_Name__c, 'Name copied from response');
        System.assertEquals('cus_test_123', sc.Stripe_Customer_ID__c, 'Stripe ID copied from response');
    }

    @IsTest
    static void test_multipleContacts_success_allContactsUpdated() {
        // Create multiple contacts
        Map<Id, Contact> contactMap = createContactsAndMap(3);
        Set<Id> ids = new Set<Id>(contactMap.keySet());

        Test.setMock(HttpCalloutMock.class, new SuccessCustomerCreateMock(ids));

        Test.startTest();
        System.enqueueJob(new ContactStripeSyncQueueable(contactMap));
        Test.stopTest();

        // Verify all contacts updated and Stripe_Customer__c records created
        List<Contact> updated = [SELECT Id, Stripe_Customer_ID__c FROM Contact WHERE Id IN :ids ORDER BY Id];
        System.assertEquals(3, updated.size(), 'Expect 3 updated contacts');
        for (Contact c : updated) {
            System.assertEquals('cus_test_123', c.Stripe_Customer_ID__c, 'All contacts should be stamped with returned Stripe ID');
        }

        Integer stripeRecords = [SELECT COUNT() FROM Stripe_Customer__c WHERE Contact__c IN :ids];
        System.assertEquals(3, stripeRecords, 'One Stripe_Customer__c per contact should be created');
    }

    @IsTest
    static void test_nonSuccessResponse_noUpdatesNoInserts() {
        Map<Id, Contact> contactMap = createContactsAndMap(1);
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
        Map<Id, Contact> contactMap = createContactsAndMap(1);
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

    @IsTest
    static void test_partialRecordsInInput_onlyExistingContactsProcessed() {
        // Create a single real contact and also include a fake Id in map
        Map<Id, Contact> realMap = createContactsAndMap(1);
        Id realId = realMap.keySet().iterator().next();

        // Fake contact Id (non-existent in DB)
        Id fakeId;
        // Construct a 15-char fake Id of Contact prefix (003) for realism; even if invalid, SOQL IN filter will ignore it
        fakeId = (Id)('003000000000000');

        Map<Id, Contact> input = new Map<Id, Contact>();
        input.putAll(realMap);
        input.put(fakeId, new Contact(FirstName='Ghost', LastName='Contact', Email='ghost@example.com'));

        Test.setMock(HttpCalloutMock.class, new SuccessCustomerCreateMock(new Set<Id>{ realId }));

        Test.startTest();
        System.enqueueJob(new ContactStripeSyncQueueable(input));
        Test.stopTest();

        // Real contact should be processed, fake should be ignored due to SOQL filter
        Contact updated = [SELECT Id, Stripe_Customer_ID__c FROM Contact WHERE Id = :realId];
        System.assertEquals('cus_test_123', updated.Stripe_Customer_ID__c, 'Real contact should be updated');

        Integer stripeForReal = [SELECT COUNT() FROM Stripe_Customer__c WHERE Contact__c = :realId];
        System.assertEquals(1, stripeForReal, 'Stripe record should exist for real contact');

        // No Stripe records linked to the fake id can exist
        System.assertEquals(0, [SELECT COUNT() FROM Stripe_Customer__c WHERE Contact__c = :fakeId], 'No records should be created for non-existent Id');
    }
}