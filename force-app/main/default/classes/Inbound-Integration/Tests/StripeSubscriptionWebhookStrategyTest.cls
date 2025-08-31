@isTest
public with sharing class StripeSubscriptionWebhookStrategyTest {
  @isTest
  static void testHandleCreateSubscriptionSuccess() {
    Stripe_Customer__c newCustomer = new Stripe_Customer__c();
    newCustomer.Customer_Email__c = 'test@email.com';
    insert newCustomer;
    Stripe_Subscription__c newSubscription = new Stripe_Subscription__c();
    newSubscription.Stripe_Customer__c = newCustomer.Id;
    //newSubscription.Stripe_Subscription_ID__c
    //When the Stripe Subscription record is created is Salesforce, Stripe's subscription ID is not yet known. We will get this information from the webhook event.
    insert newSubscription;

    String subscriptionId = newSubscription.Id;

    String jsonString = StripeWebhookTestFixtures.subscriptionEvents(
      subscriptionId,
      'customer.subscription.created'
    );

    Test.startTest();

    StripeSubscriptionWebhookStrategy strategy = new StripeSubscriptionWebhookStrategy();
    Integer result = strategy.handle(jsonString);

    Test.stopTest();

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

    Assert.areEqual(422, result, 'Expected response code 422');
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

    Assert.areEqual(422, result, 'Expected response code 422');
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

    Assert.areEqual(422, result, 'Expected response code 422');
  }

  @isTest
  static void testHandleUpdateSubscriptionSuccess() {
    Stripe_Customer__c newCustomer = new Stripe_Customer__c();
    newCustomer.Customer_Email__c = 'test@email.com';
    insert newCustomer;
    Stripe_Subscription__c newSubscription = new Stripe_Subscription__c();
    newSubscription.Stripe_Customer__c = newCustomer.Id;
    //newSubscription.Stripe_Subscription_ID__c
    //When the Stripe Subscription record is created is Salesforce, Stripe's subscription ID is not yet known. We will get this information from the webhook event.
    insert newSubscription;

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
  }

  @isTest
  static void testHandleCancelSubscriptionSuccess() {
    Stripe_Customer__c newCustomer = new Stripe_Customer__c();
    newCustomer.Customer_Email__c = 'test@email.com';
    insert newCustomer;
    Stripe_Subscription__c newSubscription = new Stripe_Subscription__c();
    newSubscription.Stripe_Customer__c = newCustomer.Id;
    newSubscription.Stripe_Subscription_ID__c = 'sub_1RwbCy4hwnEBsWxgVxLeHnl4';
    insert newSubscription;

    String subscriptionId = String.valueOf(newSubscription.Id);
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
  }
}
