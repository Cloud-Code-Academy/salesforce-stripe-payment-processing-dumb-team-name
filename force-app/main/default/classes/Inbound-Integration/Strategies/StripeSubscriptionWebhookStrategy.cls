public without sharing class StripeSubscriptionWebhookStrategy implements IStripeWebhookStrategy {
  public Integer handle(String requestBody) {
    Logger.info('Executing subscription strategy.');

    StripeWebhookSubscriptionWrapper wrapper = StripeWebhookSubscriptionWrapper.parse(
      requestBody
    );

    Integer result;

    switch on wrapper.type {
      when 'customer.subscription.updated' {
        result = subscriptionUpdate(wrapper);
      }
      when 'customer.subscription.deleted' {
        result = subscriptionDelete(wrapper);
      }
    }

    return result;
  }

  public Integer subscriptionUpdate(StripeWebhookSubscriptionWrapper wrapper) {
    String subId = wrapper.data.object_x.id;

    Stripe_Subscription__c sub = [
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
        Sync_Status__c
      FROM Stripe_Subscription__c
      WHERE Stripe_Subscription_ID__c = :subId
      LIMIT 1
    ];

    Integer amount =
      wrapper.data.object_x.items.data[0].plan.amount *
      wrapper.data.object_x.items.data[0].quantity;

    sub.Amount__c = amount;
    sub.Currency__c = wrapper.data.object_x.items.data[0].plan.currency_x;

    Long timestampStart = wrapper.data.object_x.items.data[0]
      .current_period_start;
    Datetime dateStart = Datetime.newInstance(timestampStart * 1000L); // -> GMT

    Long timestampEnd = wrapper.data.object_x.items.data[0].current_period_end;
    Datetime dateEnd = Datetime.newInstance(timestampEnd * 1000L);

    sub.Current_Period_Start__c = dateStart;
    sub.Current_Period_End__c = dateEnd;
    sub.Product_Plan_Name__c = wrapper.data.object_x.items.data[0].plan.product;

    //TODO: what to do with status?
    sub.Stripe_Price_ID__c = wrapper.data.object_x.items.data[0].price.id;
    sub.Stripe_Customer__c = wrapper.customer;
    sub.Sync_Status__c = 'Synced';
    try {
      update sub;
      Logger.info('Subscription sync successfull.');
      Logger.saveLog();
      return 201;
    } catch (Exception e) {
      Logger.error('Error during subscription sync');
      Logger.saveLog();
      return 401;
    }
  }

  public Integer subscriptionDelete(StripeWebhookSubscriptionWrapper wrapper) {
    Stripe_Subscription__c sub = [
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
        Sync_Status__c
      FROM Stripe_Subscription__c
      WHERE Stripe_Subscription_ID__c = :wrapper.data.object_x.id
      LIMIT 1
    ];

    sub.Status__c = 'Canceled';
    update sub;
    return 201;
  }
}
