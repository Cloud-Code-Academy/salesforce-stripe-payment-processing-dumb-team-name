@IsTest
private class ContactService_Test {

    
    private class OkHttpMock implements HttpCalloutMock {
        private integer counter = 0;

        public HTTPResponse respond(HTTPRequest req) {
            counter++;
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"id":"cus_test' + counter + '","email":"test' + counter + '@example.com","name":"Test User ' + counter + '"}');
            res.setHeader('Content-Type', 'application/json');
            return res;
        }
    } 

    
    private static Contact makeContact(String firstName, String lastName, String email) {
        Contact c = new Contact(
            FirstName = firstName,
            LastName  = lastName,
            Email     = email
        );
        insert c;
        return c;
    }

    @IsTest
    static void handleNewContacts_enqueuesJob_withNonEmptyMap() {
        Contact c1 = makeContact('Alice', 'Tester', 'alice.tester@example.com');
        Contact c2 = makeContact('Bob', 'Verifier', 'bob.verifier@example.com');
        Contact c3 = makeContact('Bob2', 'Verifier2', 'bob.verifier2@example.com');

        Map<Id, Contact> newContactMap = new Map<Id, Contact>{
            c1.Id => c1,
            c2.Id => c2,
            c3.Id => c3
        };

        Integer beforeJobs = Limits.getQueueableJobs();
        ContactService.handleNewContacts(newContactMap);
        Integer afterJobs = Limits.getQueueableJobs();
        System.assertEquals(beforeJobs + 1, afterJobs, 'Expected exactly one queueable job to be enqueued.');
    }

    @IsTest
    static void handleNewContacts_enqueuesJob_withNullMap() {
        Map<Id, Contact> nullMap = null;
        Integer beforeJobs = Limits.getQueueableJobs();
        ContactService.handleNewContacts(nullMap);
        Integer afterJobs = Limits.getQueueableJobs();
        System.assertEquals(beforeJobs, afterJobs, 'No queueables should be enqueued.');
    }

    @IsTest
    static void handleNewContacts_executesQueueable_doesNotError_withMockedCallouts() {
        Test.setMock(HttpCalloutMock.class, new OkHttpMock());

        Contact c = makeContact('Charlie', 'Runner', 'charlie.runner@example.com');
        Map<Id, Contact> newContactMap = new Map<Id, Contact>{ c.Id => c };

        Test.startTest();
        ContactService.handleNewContacts(newContactMap);
        Test.stopTest();

        System.assert(true, 'Async Queueable executed without unhandled exceptions using mocked callouts.');
    }
}
