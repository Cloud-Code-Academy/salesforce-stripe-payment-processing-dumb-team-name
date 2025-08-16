public with sharing class StripeAPI {

    public static final String NAMED_CREDENTIAL = 'STRIPE_NAMED_CREDENTIAL';
    
    public static HttpResponse doPost(String endpoint, String body) {

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        req.setEndpoint('callout:' + NAMED_CREDENTIAL + endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        try{
            res = h.send(req);
            if(res.getStatusCode() != 200){
                throw new StripeAPIException('Callout error: Status code ' + res.getStatusCode());
            }
        }catch(Exception e){
            Logger.Error(e.getMessage());
        }
        return res; 
    }
    public class StripeAPIException extends Exception{}
}