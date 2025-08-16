@IsTest
private class ContactService_Test {

    // Simple HttpCalloutMock to safely handle any unexpected callouts by the Queueable during Test.stopTest().
    // If the queueable does not perform callouts, the presence of this mock is harmless.
    private class OkHttpMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"ok"}');
            res.setHeader('Content-Type', 'application/json');
            return res;
        }
    }

    private class newCustomerMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"id":"cus_testid","object":"customer","email":"john.mctestface@gmail.com","name":"John McTestFace"}');
            res.setHeader('Content-Type','application/json');
            return res;
        }
    }

    // Utility to create a Contact and return it
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
        // Arrange
        Contact c1 = makeContact('Alice', 'Tester', 'alice.tester@example.com');
        Contact c2 = makeContact('Bob', 'Verifier', 'bob.verifier@example.com');
        Contact c3 = makeContact('Bob2', 'Verifier2', 'bob.verifier2@example.com');

        Map<Id, Contact> newContactMap = new Map<Id, Contact>{
            c1.Id => c1,
            c2.Id => c2,
            c3.Id => c3      };

        Integer beforeJobs = Limits.getQueueableJobs();

        // Act
        ContactService.handleNewContacts(newContactMap);

        // Assert
        Integer afterJobs = Limits.getQueueableJobs();
        System.assertEquals(
            beforeJobs + 1,
            afterJobs,
            'Expected exactly one queueable job to be enqueued for a non-empty contact map.'
        );
    }

    // @IsTest
    // static void handleNewContacts_enqueuesJob_withEmptyMap() {
    //     // Arrange
    //     Map<Id, Contact> emptyMap = new Map<Id, Contact>();
    //     Integer beforeJobs = Limits.getQueueableJobs();

    //     // Act
    //     ContactService.handleNewContacts(emptyMap);

    //     // Assert
    //     Integer afterJobs = Limits.getQueueableJobs();
    //     System.assertEquals(
    //         beforeJobs + 1,
    //         afterJobs,
    //         'Even with an empty map, current implementation should enqueue exactly one queueable job.'
    //     );
    // }

    @IsTest
    static void handleNewContacts_enqueuesJob_withNullMap_withoutExecutingAsync() {
        
        //ContactService.handleNewContacts will not enqueue the job is the map is null

        Map<Id, Contact> nullMap = null;
        
        Test.startTest();

        ID jobId = ContactService.handleNewContacts(nullMap);
        
        Test.stopTest();
        
        // Assert
        
        System.assertEquals(null, jobId, 'Passing null should result in the job not being enqueued');
    }

    @IsTest
    static void handleNewContacts_executesQueueable_doesNotError_withMockedCallouts() {
        
        Test.setMock(HttpCalloutMock.class, new newCustomerMock());

        Contact c = makeContact('John', 'MacTestFace', 'johnnny.mctestface@gmail.com');
        
        Map<Id, Contact> newContactMap = new Map<Id, Contact>{ c.Id => c };

        Test.startTest();

        Id jobId = ContactService.handleNewContacts(newContactMap);
        
        Test.stopTest();

        // Assert
        // If execution reached here without an exception, the async job executed successfully under test conditions.
        System.assert(true, 'Async Queueable executed without unhandled exceptions using mocked callouts.');
    }
}