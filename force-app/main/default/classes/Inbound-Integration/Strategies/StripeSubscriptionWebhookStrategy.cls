/**
 * @description Contains the logic for handling Stripe inbound subscription events
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Stripe Inbound Integration
 */
public without sharing class StripeSubscriptionWebhookStrategy implements IStripeWebhookStrategy {
  /**
   * @description Main logic for handling inbound subscription events
   *
   * @return Integer Http response code
   */
  public Integer handle(String requestBody) {
    Logger.info('Executing subscription strategy.');
    StripeWebhookSubscriptionWrapper wrapper = StripeWebhookSubscriptionWrapper.parse(
      requestBody
    );

    Integer result;

    switch on wrapper.type {
      when 'customer.subscription.created' {
        result = subscriptionCreate(wrapper);
      }
      when 'customer.subscription.updated' {
        result = subscriptionUpdate(wrapper);
      }
      when 'customer.subscription.deleted' {
        result = subscriptionDelete(wrapper);
      }
    }

    return result;
  }

  /**
   * @description Logic for subscription created events
   *
   * @return Integer Http response code
   */
  public Integer subscriptionCreate(StripeWebhookSubscriptionWrapper wrapper) {
    String SubscriptionId = wrapper.data.object_x.metadata.Subscription_Id;

    try {
      if (SubscriptionId == null) {
        throw new StripeSubscriptionWebhookStrategyException(
          'Subscription Id is null'
        );
      }
    } catch (StripeSubscriptionWebhookStrategyException e) {
      Logger.error(e.getMessage());
      Logger.saveLog();
      return 422;
    }
    Stripe_Subscription__c sub = new Stripe_Subscription__c();

    try {
      sub = [
        SELECT
          Id,
          Amount__c,
          Currency__c,
          Current_Period_End__c,
          Current_Period_Start__c,
          Product_Plan_Name__c,
          Status__c,
          Stripe_Customer__c,
          Stripe_Price_ID__c,
          Stripe_Subscription_ID__c,
          Stripe_Subscription_Item_ID__c,
          Sync_Status__c
        FROM Stripe_Subscription__c
        WHERE Id = :SubscriptionId
        LIMIT 1
      ];
    } catch (QueryException e) {
      Logger.error('Query Exception  : ' + e.getMessage());
      Logger.saveLog();
      return 422;
    }

    //Check this
    sub.Stripe_Subscription_ID__c = wrapper.data.object_x.id;
    sub.Stripe_Subscription_Item_ID__c = wrapper.data.object_x.items.data[0].id;
    sub.Sync_Status__c = 'Synced';

    Integer response;

    try {
      update sub;
      Logger.info(
        'Subscription ' +
          subscriptionId +
          ' successfully synced after creation.'
      );
      response = 204;
    } catch (DmlException e) {
      Logger.error(e.getMessage());
      Logger.error(
        'DML Exception. Subscription ' +
          subscriptionId +
          ' was not successfully synced.'
      );
      response = 422;
    } catch (Exception e) {
      Logger.error(
        'Unexpected exception. Subscription record ' +
          subscriptionId +
          ' was not successfully synced. Error message: ' +
          e.getMessage()
      );

      response = 500;
    } finally {
      Logger.saveLog();
    }
    return response;
  }

  /**
   * @description Logic for subscription updated events
   *
   * @return Integer Http response code
   */
  public Integer subscriptionUpdate(StripeWebhookSubscriptionWrapper wrapper) {
    // Note: This is referring to the record Id in Salesforce which is sent in the metadata of the request
    String SubscriptionId = wrapper.data.object_x.metadata.Subscription_Id;

    try {
      if (SubscriptionId == null) {
        throw new StripeSubscriptionWebhookStrategyException(
          'Subscription Id is null'
        );
      }
    } catch (StripeSubscriptionWebhookStrategyException e) {
      Logger.error(e.getMessage());
      Logger.saveLog();
      return 422;
    }
    Stripe_Subscription__c sub = new Stripe_Subscription__c();
    try {
      sub = [
        SELECT
          Id,
          Amount__c,
          Currency__c,
          Current_Period_End__c,
          Current_Period_Start__c,
          Product_Plan_Name__c,
          Status__c,
          Stripe_Customer__c,
          Stripe_Price_ID__c,
          Stripe_Subscription_ID__c,
          Stripe_Subscription_Item_ID__c,
          Sync_Status__c
        FROM Stripe_Subscription__c
        WHERE Id = :subscriptionId
        LIMIT 1
      ];
    } catch (QueryException e) {
      Logger.error('Query Exception: ' + e.getMessage());
      Logger.saveLog();
      return 422;
    }

    Integer amount =
      wrapper.data.object_x.items.data[0].plan.amount *
      wrapper.data.object_x.items.data[0].quantity;

    //Stripe sends 10000 for $100.00
    sub.Amount__c = amount / 100;
    sub.Currency__c = wrapper.data.object_x.items.data[0].plan.currency_x;

    sub.Stripe_Subscription_Item_ID__c = wrapper.data.object_x.items.data[0].id;

    //Stripe sends time in Unix format
    sub.Current_Period_Start__c = DateUtils.timestampToDatetimeConverter(
      wrapper.data.object_x.items.data[0].current_period_start
    );
    sub.Current_Period_End__c = DateUtils.timestampToDatetimeConverter(
      wrapper.data.object_x.items.data[0].current_period_end
    );

    sub.Product_Plan_Name__c = wrapper.data.object_x.items.data[0].plan.product;

    // Business rule: Subscriptions cannot be re-assigned to another customer
    sub.Stripe_Price_ID__c = wrapper.data.object_x.items.data[0].price.id;
    sub.Sync_Status__c = 'Synced';

    try {
      update sub;
      Logger.info('Subscription sync successfull.');
    } catch (DmlException e) {
      Logger.error('Error during subscription sync');
      Logger.saveLog();
      return 422;
    } catch (Exception e) {
      Logger.error('Unknown exception');
      Logger.saveLog();
      return 500;
    }
    Logger.saveLog();
    return 204;
  }

  /**
   * @description Contains logic for handling subscription cancelled events
   *
   * @return Integer Http response code
   */
  public Integer subscriptionDelete(StripeWebhookSubscriptionWrapper wrapper) {
    String SubscriptionRecordId = wrapper.data.object_x.metadata.Subscription_Id;

    Stripe_Subscription__c sub = new Stripe_Subscription__c();

    try {
      sub = [
        SELECT
          Id,
          Amount__c,
          Currency__c,
          Current_Period_End__c,
          Current_Period_Start__c,
          Product_Plan_Name__c,
          Stripe_Price_ID__c,
          Stripe_Subscription_ID__c,
          Stripe_Subscription_Item_ID__c,
          Sync_Status__c
        FROM Stripe_Subscription__c
        WHERE Id = :SubscriptionRecordId
        LIMIT 1
      ];
    } catch (QueryException e) {
      Logger.error('QueryException: ' + e.getMessage());
      Logger.saveLog();
      return 422;
    }

    sub.Status__c = 'Canceled';
    sub.Sync_Status__c = 'Synced';

    try {
      update sub;
      Logger.info('Subscription successfully cancelled');
    } catch (DmlException e) {
      Logger.error('Sync error');
      return 422;
    } catch (Exception e) {
      Logger.error('Unknown error');
      return 500;
    }
    Logger.saveLog();
    return 204;
  }

  public class StripeSubscriptionWebhookStrategyException extends Exception {
  }
}
