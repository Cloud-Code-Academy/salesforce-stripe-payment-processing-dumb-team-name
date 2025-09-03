global with sharing class StripeCustomerSyncScheduler implements Schedulable {
  global void execute(SchedulableContext sc) {
    Database.executeBatch(new StripeCustomerSyncBatch(), 50);
  }
}
