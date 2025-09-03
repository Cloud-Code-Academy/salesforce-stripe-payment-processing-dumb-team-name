public with sharing class StripeUpdateCustomerQueueable implements Queueable, Database.AllowsCallouts {
  private Map<Id, Stripe_Customer__c> updateStripeCustomersMap;

  public StripeUpdateCustomerQueueable(
    Map<Id, Stripe_Customer__c> updateStripeCustomersMap
  ) {
    this.updateStripeCustomersMap = updateStripeCustomersMap;
  }

  public void execute(QueueableContext qc) {
    List<Stripe_Customer__c> customerList = [
      SELECT
        Id,
        Customer_Name__c,
        Customer_Email__c,
        Customer_Phone__c,
        Stripe_Customer_ID__c
      FROM Stripe_Customer__c
      WHERE
        Id IN :updateStripeCustomersMap.keySet()
        AND Stripe_Customer_ID__c != NULL
    ];

    for (Stripe_Customer__c customer : customerList) {
      updateCustomer(customer);
    }
  }

  private void updateCustomer(Stripe_Customer__c customer) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      'callout:STRIPE_NAMED_CREDENTIAL' +
        '/v1/customers/' +
        customer.Stripe_Customer_ID__c
    );
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

    String body = '';
    if (!String.isBlank(customer.Customer_Name__c))
      body +=
        'name=' +
        EncodingUtil.urlEncode(customer.Customer_Name__c, 'UTF-8') +
        '&';
    if (!String.isBlank(customer.Customer_Email__c))
      body +=
        'email=' +
        EncodingUtil.urlEncode(customer.Customer_Email__c, 'UTF-8') +
        '&';
    if (!String.isBlank(customer.Customer_Phone__c))
      body +=
        'phone=' +
        EncodingUtil.urlEncode(customer.Customer_Phone__c, 'UTF-8') +
        '&';

    if (body.endsWith('&')) {
      body = body.substring(0, body.length() - 1);
    }
    System.debug('Stripe request body for ' + customer.Id + ': ' + body);
    req.setBody(body);

    try {
      HttpResponse res = http.send(req);

      if (res.getStatusCode() == 200) {
        Logger.info('Stripe Customer Updated Successfully ' + customer.Id);
      } else {
        Logger.error(
          'Stripe failed to update Subscription ' +
            customer.Id +
            ' : ' +
            res.getBody()
        );
        Logger.saveLog();
      }
    } catch (Exception e) {
      Logger.error(
        'Stripe update exception for ' + customer.Id + ' : ' + e.getMessage()
      );
      Logger.saveLog();
    }
  }
}
