@isTest
public with sharing class StripeSubscriptionWebhookStrategyTest {
  @isTest
  static void testHandleCreateSubscriptionSuccess() {
    TriggerBypass.bypassStripeSubscription = true;

    Stripe_Customer__c newCustomer = StripeTestDataFactory.createStripeCustomer(
      true
    );
    Stripe_Subscription__c newSubscription = StripeTestDataFactory.createStripeSubscription(
      true,
      newCustomer.Id
    );

    String subscriptionId = newSubscription.Id;

    String jsonString = StripeWebhookTestFixtures.subscriptionEvents(
      subscriptionId,
      'customer.subscription.created'
    );

    Test.startTest();

    StripeSubscriptionWebhookStrategy strategy = new StripeSubscriptionWebhookStrategy();
    Integer result = strategy.handle(jsonString);

    Test.stopTest();

    TriggerBypass.bypassStripeSubscription = false;

    Stripe_Subscription__c createdSubscription = [
      SELECT
        Stripe_Subscription_ID__c,
        Stripe_Subscription_Item_ID__c,
        Sync_Status__c
      FROM Stripe_Subscription__c
      WHERE Id = :subscriptionId
      LIMIT 1
    ];

    Assert.areEqual(204, result, 'Expected the operation to succeed');
    Assert.areNotEqual(
      null,
      createdSubscription.Stripe_Subscription_ID__c,
      'Stripe_Subscription_ID__c should not be null'
    );
    Assert.areNotEqual(
      null,
      createdSubscription.Stripe_Subscription_Item_ID__c,
      'Stripe_Subscription_Item_ID__c should not be null.'
    );
    Assert.areEqual(
      'Synced',
      createdSubscription.Sync_Status__c,
      'Sync status does not match. Expected: Synced. Actual: ' +
      createdSubscription.Sync_Status__c
    );
  }

  /**
   * @description This tests handling of a request body that does not include the record id for the Stripe_Subscription__c record in Salesforce. This method should return a response code of 422
   */
  @isTest
  static void testHandleCreateSubscriptionIdNull() {
    Stripe_Customer__c newCustomer = StripeTestDataFactory.createStripeCustomer(
      true
    );
    Stripe_Subscription__c newSubscription = StripeTestDataFactory.createStripeSubscription(
      true,
      newCustomer.Id
    );
    String jsonString = StripeWebhookTestFixtures.subscriptionEvents(
      null,
      'customer.subscription.created'
    );

    Test.startTest();

    StripeSubscriptionWebhookStrategy strategy = new StripeSubscriptionWebhookStrategy();
    Integer result = strategy.handle(jsonString);

    Test.stopTest();

    Assert.areEqual(400, result, 'Expected response code 400');
  }

  /**
   * @description This tests handling of a request body that does not include the record id for the Stripe_Subscription__c record in Salesforce. This method should return a response code of 422
   */
  @isTest
  static void testHandleCancelSubscriptionIdNull() {
    Stripe_Customer__c newCustomer = StripeTestDataFactory.createStripeCustomer(
      true
    );
    Stripe_Subscription__c newSubscription = StripeTestDataFactory.createStripeSubscription(
      true,
      newCustomer.Id
    );
    String jsonString = StripeWebhookTestFixtures.subscriptionEvents(
      null,
      'customer.subscription.deleted'
    );

    Test.startTest();

    StripeSubscriptionWebhookStrategy strategy = new StripeSubscriptionWebhookStrategy();
    Integer result = strategy.handle(jsonString);

    Test.stopTest();

    Assert.areEqual(400, result, 'Expected response code 400');
  }

  /**
   * @description This tests handling of a request body that does not include the record id for the Stripe_Subscription__c record in Salesforce. This method should return a response code of 422
   */
  @isTest
  static void testHandleUpdateSubscriptionIdNull() {
    Stripe_Customer__c newCustomer = StripeTestDataFactory.createStripeCustomer(
      true
    );
    Stripe_Subscription__c newSubscription = StripeTestDataFactory.createStripeSubscription(
      true,
      newCustomer.Id
    );
    String jsonString = StripeWebhookTestFixtures.subscriptionEvents(
      null,
      'customer.subscription.updated'
    );

    Test.startTest();

    StripeSubscriptionWebhookStrategy strategy = new StripeSubscriptionWebhookStrategy();
    Integer result = strategy.handle(jsonString);

    Test.stopTest();

    Assert.areEqual(400, result, 'Expected response code 400');
  }

  @isTest
  static void testHandleUpdateSubscriptionSuccess() {
    TriggerBypass.bypassStripeSubscription = true;
    Stripe_Customer__c newCustomer = StripeTestDataFactory.createStripeCustomer(
      true
    );
    Stripe_Subscription__c newSubscription = StripeTestDataFactory.createStripeSubscription(
      true,
      newCustomer.Id
    );

    String subscriptionId = newSubscription.Id;

    String jsonString = StripeWebhookTestFixtures.subscriptionEvents(
      subscriptionId,
      'customer.subscription.updated'
    );

    Test.startTest();

    StripeSubscriptionWebhookStrategy strategy = new StripeSubscriptionWebhookStrategy();
    Integer result = strategy.handle(jsonString);

    Test.stopTest();

    Stripe_Subscription__c updatedSubscription = [
      SELECT Amount__c
      FROM Stripe_Subscription__c
      WHERE Id = :subscriptionId
      LIMIT 1
    ];

    Assert.areEqual(204, result, 'Expected the operation to succeed');
    Assert.areEqual(
      80.00,
      updatedSubscription.Amount__c,
      'Expected 80.00, actual: ' + updatedSubscription.Amount__c
    );
    TriggerBypass.bypassStripeSubscription = false;
  }

  @isTest
  static void testHandleCancelSubscriptionSuccess() {
    TriggerBypass.bypassStripeSubscription = true;
    Stripe_Customer__c newCustomer = StripeTestDataFactory.createStripeCustomer(
      true
    );
    Stripe_Subscription__c newSubscription = StripeTestDataFactory.createStripeSubscription(
      true,
      newCustomer.Id
    );
    String subscriptionId = newSubscription.Id;

    String jsonString = StripeWebhookTestFixtures.subscriptionEvents(
      subscriptionId,
      'customer.subscription.deleted'
    );

    Test.startTest();

    StripeSubscriptionWebhookStrategy strategy = new StripeSubscriptionWebhookStrategy();
    Integer result = strategy.handle(jsonString);

    Test.stopTest();

    Stripe_Subscription__c updatedSubscription = [
      SELECT Status__c
      FROM Stripe_Subscription__c
      WHERE Id = :subscriptionId
      LIMIT 1
    ];

    Assert.areEqual(204, result, 'Expected the operation to succeed');
    Assert.areEqual(
      'canceled',
      updatedSubscription.Status__c,
      'Expected status to be canceled, actual status: ' +
      updatedSubscription.Status__c
    );

    TriggerBypass.bypassStripeSubscription = false;
  }
}
