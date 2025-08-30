public with sharing class StripeCustomerSyncService {
  public static StripeCustomerSyncBatchResponseWrapper syncCustomer(
    Stripe_Customer__c customer
  ) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      'callout:STRIPE_NAMED_CREDENTIAL' +
        '/v1/customers/' +
        customer.Stripe_Customer_ID__c
    );
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    HttpResponse res = http.send(req);
    StripeCustomerSyncBatchResponseWrapper wrapper = (StripeCustomerSyncBatchResponseWrapper) JSON.deserialize(
      res.getBody(),
      StripeCustomerSyncBatchResponseWrapper.class
    );
    return wrapper;
  }
}
