@RestResource(urlMapping='/stripe/webhooks/*')
global without sharing class StripeEventsWebhook {
    
    @HttpPost
    global static void returnBody(){
        RestRequest req = RestContext.request;
        String body = req.requestBody.toString();
        system.debug('This is the body' + body);
    }
}