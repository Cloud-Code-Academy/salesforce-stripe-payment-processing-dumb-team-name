@IsTest
global class StripeAPIMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake HTTP response
        HttpResponse res = new HttpResponse();
        
        // Simulate a successful response from Stripe API
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id": "cus_mock123", "object": "customer"}');
        res.setStatusCode(200);
        
        return res;
    }
}