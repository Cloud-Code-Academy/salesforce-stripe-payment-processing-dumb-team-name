public with sharing class CreateCustomerStrategyTest implements IStripeStrategy {
    public HttpResponse execute(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json');
        res.setStatusCode(200);
        res.setBody('{"id":"cus_test123","email":"john.test@gmail.com","name":"Walter White"}');
        return res;
    }
}