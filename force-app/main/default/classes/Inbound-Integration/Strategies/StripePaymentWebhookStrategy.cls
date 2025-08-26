/**
 * @description Logic for handling Stripe invoice webhook events
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Stripe Inbound Integration
 */

public without sharing class StripePaymentWebhookStrategy implements IStripeWebhookStrategy {
  /**
   * @description The main method for handling Stripe invoice webhook events
   *
   * @return Integer Http status code
   */

  public Integer handle(String requestBody) {
    Logger.info('Executing payment strategy');

    StripeWebhookInvoiceWrapper wrapper = StripeWebhookInvoiceWrapper.parse(
      requestBody
    );

    Integer result;
    switch on wrapper.type {
      when 'invoice.paid' {
        result = invoicePaid(wrapper);
      }
      when 'customer.subscription.deleted' {
        result = invoicePaymentFailed(wrapper);
      }
    }

    return result;
  }

  /**
   * @description Logic for invoice paid events
   *
   * @return Integer http response code
   */
  public Integer invoicePaid(StripeWebhookInvoiceWrapper wrapper) {
    Integer result;

    Stripe_Subscription__c sub = getSubscription(wrapper);

    Payment_Transaction__c payment = new Payment_Transaction__c();
    payment.Amount__c = wrapper.data.object_x.amount_paid;
    payment.Currency__c = wrapper.data.object_x.currency_x;
    payment.Transaction_Date__c = DateUtils.timestampToDatetimeConverter(
      wrapper.created
    );
    //todo: Payment intent id is not delivered with invoice.paid event
    //todo: status on event is 'paid' -- add a guard clause
    //todo: check Stripe definitions and values for "collection_method". Does "charge_automatically" mean payment is by card?
    payment.Status__c = 'Succeeded';
    payment.Stripe_Customer__c = sub.Stripe_Customer__c;
    payment.Stripe_Subscription__c = sub.Id;

    try {
      insert payment;
      Logger.info(
        'Payment transaction ' + payment.Id + ' successfully inserted.'
      );
      result = 201;
    } catch (DmlException e) {
      Logger.error(e.getMessage());
      result = 422;
    } catch (Exception e) {
      Logger.error(e.getMessage());
      result = 500;
    }
    Logger.saveLog();
    return result;
  }

  /**
   * @description The logic for handling invoice payment failed events
   *
   * @return Integer Http response code
   */

  //TODO: still needs to be done
  public Integer invoicePaymentFailed(StripeWebhookInvoiceWrapper wrapper) {
    return null;
  }

  /**
   * @description Helper method retrieves Stripe Subscription record
   *
   * @return Stripe_Subscription__c
   */
  public Stripe_Subscription__c getSubscription(
    StripeWebhookInvoiceWrapper wrapper
  ) {
    String subId = getSubscriptionId(wrapper);

    Stripe_Subscription__c sub = [
      SELECT Id, Stripe_Customer__c, Stripe_Subscription_ID__c
      FROM Stripe_Subscription__c
      WHERE Stripe_Subscription_ID__c = :subId
      LIMIT 1
    ];

    return sub;
  }

  /**
   * @description Helpler method. Get the subscription id
   *
   * @return String Stripe subscription Id
   */
  public String getSubscriptionId(StripeWebhookInvoiceWrapper wrapper) {
    String subId = wrapper.data.object_x.lines.data[0]
      .parent.subscription_item_details.subscription;

    return subId;
  }
}
