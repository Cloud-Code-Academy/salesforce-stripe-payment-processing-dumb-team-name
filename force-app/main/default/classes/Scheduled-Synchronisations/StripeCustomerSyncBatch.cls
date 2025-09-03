global with sharing class StripeCustomerSyncBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
  global Database.QueryLocator start(Database.BatchableContext bc) {
    // Accounts that were created today
    return Database.getQueryLocator(
      [
        SELECT Id, Default_Payment_Method__c, Stripe_Customer_ID__c, CreatedDate
        FROM Stripe_Customer__c
        WHERE
          CreatedDate >= :DateTime.newInstance(
            Date.today(),
            Time.newInstance(0, 0, 0, 0)
          )
          AND CreatedDate < :DateTime.newInstance(
            Date.today().addDays(1),
            Time.newInstance(0, 0, 0, 0)
          )
      ]
    );
  }

  global void execute(
    Database.BatchableContext bc,
    List<Stripe_Customer__c> scope
  ) {
    List<Stripe_Customer__c> toUpdate = new List<Stripe_Customer__c>();

    for (Stripe_Customer__c customer : scope) {
      // Make API call - 1 per record
      StripeCustomerSyncBatchResponseWrapper res = StripeCustomerSyncService.syncCustomer(
        customer
      );
      try {
        customer.Default_Payment_Method__c = res.invoice_settings.default_payment_method;
        toUpdate.add(customer);
      } catch (NullPointerException e) {
        Logger.error(
          'NullPointerException: There was no value for default source.'
        );
      }
    }
    try {
      update toUpdate;
      Logger.info('Batch update successful');
    } catch (DmlException e) {
      Logger.error('Batch update not successful. Message: ' + e.getMessage());
    }
  }
  global void finish(Database.BatchableContext bc) {
    Logger.info(bc.getJobId() + ' successfully completed');
    Logger.saveLog();
  }
}
