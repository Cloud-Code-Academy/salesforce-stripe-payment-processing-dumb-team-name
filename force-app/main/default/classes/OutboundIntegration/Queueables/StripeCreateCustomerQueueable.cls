public with sharing class StripeCreateCustomerQueueable implements Queueable, Database.AllowsCallouts {
  private Map<Id, Contact> contactsToSyncMap;

  public StripeCreateCustomerQueueable(Map<Id, Contact> contactsToSyncMap) {
    this.contactsToSyncMap = contactsToSyncMap;
  }

  public void execute(QueueableContext qc) {
    List<Contact> contactsToUpdate = new List<Contact>();
    List<Stripe_Customer__c> stripeCustomersToInsert = new List<Stripe_Customer__c>();
    Set<Id> contactIds = contactsToSyncMap.keySet();
    List<Contact> retrievedContacts = [
      SELECT Id, FirstName, LastName, Email, Stripe_Customer_ID__c
      FROM Contact
      WHERE Id IN :contactIds
    ];

    for (Contact contactToSync : retrievedContacts) {
      StripeAPIRequestWrapper req = new StripeAPIRequestWrapper(
        contactToSync.FirstName + ' ' + contactToSync.LastName,
        contactToSync.Email
      );

      String body = req.toUrlEncodedString();

      try {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
          'callout:STRIPE_NAMED_CREDENTIAL' + '/v1/customers'
        );
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(body);

        Logger.info('Sending Stripe customer creation request', contactToSync);

        Http http = new Http();
        HTTPResponse res = http.send(request);

        if (res.getStatusCode() == 200) {
          StripeAPIResponseWrappers stripeResponse = StripeAPIResponseWrappers.parse(
            res.getBody()
          );

          contactToSync.Stripe_Customer_ID__c = stripeResponse.id;
          contactsToUpdate.add(contactToSync);

          Stripe_Customer__c newStripeCust = new Stripe_Customer__c(
            Contact__c = contactToSync.Id,
            Customer_Email__c = stripeResponse.email,
            Customer_Name__c = stripeResponse.name,
            Stripe_Customer_ID__c = stripeResponse.id
          );
          stripeCustomersToInsert.add(newStripeCust);
        } else {
          Logger.error(
              'Stripe API returned non-success status: ' + res.getStatus(),
              contactToSync
            )
            .setHttpResponseDetails(res)
            .setExceptionDetails(
              new CalloutException(
                'Status: ' + res.getStatus() + ' Body: ' + res.getBody()
              )
            );
        }
      } catch (Exception e) {
        Logger.error('Exception during Stripe callout', contactToSync)
          .setExceptionDetails(e);
      }
    }

    if (!contactsToUpdate.isEmpty()) {
      update contactsToUpdate;
    }

    if (!stripeCustomersToInsert.isEmpty()) {
      insert stripeCustomersToInsert;
    }

    Logger.saveLog();
  }
}
