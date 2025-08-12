@IsTest
public class StripeClientMock implements IStripeClient {
    public HttpResponse doPost(String endpoint, String body) {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"id":"cus_test123"}'); 
        return mockResponse;
    }
}