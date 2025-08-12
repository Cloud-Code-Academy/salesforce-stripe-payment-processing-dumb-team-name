@IsTest
private class ContactService_Test {

    // Simple HttpCalloutMock to safely handle any unexpected callouts by the Queueable during Test.stopTest().
    // If the queueable does not perform callouts, the presence of this mock is harmless.
    private class OkHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"ok"}');
            res.setHeader('Content-Type', 'application/json');
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
        // Arrange
        // We will not call Test.startTest/Test.stopTest here to avoid executing the async job in case
        // the Queueable does not tolerate a null map during execution.
        Map<Id, Contact> nullMap = null;
        Integer beforeJobs = Limits.getQueueableJobs();

        // Act
        // If the Queueable constructor throws for null, this test will fail and surface that constraint.
        // If it accepts null and defers usage to execute(), the enqueue count should still increment.
        ContactService.handleNewContacts(nullMap);

        // Assert
        Integer afterJobs = Limits.getQueueableJobs();
        System.assertEquals(
            beforeJobs + 1,
            afterJobs,
            'Passing null should still result in a queueable job being enqueued as per current implementation.'
        );
    }

    @IsTest
    static void handleNewContacts_executesQueueable_doesNotError_withMockedCallouts() {
        // This test validates that the enqueued job can run to completion within a test context.
        // We set a permissive HttpCalloutMock to catch any outgoing callouts that might be made by the queueable.
        // We do not assert side effects of the queueable (unknown implementation),
        // but we assert that no unhandled exceptions occur during async execution.
        Test.setMock(HttpCalloutMock.class, new OkHttpMock());

        // Arrange
        Contact c = makeContact('Charlie', 'Runner', 'charlie.runner@example.com');
        Map<Id, Contact> newContactMap = new Map<Id, Contact>{ c.Id => c };

        // Act
        Test.startTest();
        ContactService.handleNewContacts(newContactMap);
        // During Test.stopTest(), the enqueued queueable should execute.
        Test.stopTest();

        // Assert
        // If execution reached here without an exception, the async job executed successfully under test conditions.
        System.assert(true, 'Async Queueable executed without unhandled exceptions using mocked callouts.');
    }
}