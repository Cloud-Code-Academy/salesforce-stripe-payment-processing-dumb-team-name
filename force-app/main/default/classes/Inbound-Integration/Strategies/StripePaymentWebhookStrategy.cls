/**
 * @description Logic for handling Stripe invoice webhook events
 *
 * @author Jonathan Lyles
 * @date August 31, 2025
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
    result = invoicePayment(wrapper);

    return result;
  }

  /**
   * @description Logic for invoice paid events
   *
   * @return Integer http response code
   */
  public Integer invoicePayment(StripeWebhookInvoiceWrapper wrapper) {
    Integer result;

    Stripe_Subscription__c sub = getSubscription(wrapper);
    if (sub == null) {
      Logger.error('Response code 400: Bad request. Missing Subscription');
      return 400;
    }

    Payment_Transaction__c payment = new Payment_Transaction__c();
    // To decimal
    payment.Amount__c = wrapper.data.object_x.amount_paid / 100;
    payment.Currency__c = wrapper.data.object_x.currency_x;
    payment.Transaction_Date__c = DateUtils.timestampToDatetimeConverter(
      wrapper.created
    );

    payment.Stripe_Payment_Intent_ID__c = wrapper.data.object_x.id;
    payment.Status__c = wrapper.data.object_x.status;

    payment.Stripe_Customer__c = sub.Stripe_Customer__c;
    payment.Stripe_Subscription__c = sub.Id;
    payment.Payment_Method_Type__c = sub.

    try {
      insert payment;
      Logger.info(
        'Payment transaction ' + payment.Id + ' successfully inserted.'
      );
      result = 201;
    } catch (DmlException e) {
      System.debug('DML Exception');

      result = 422;
    } catch (Exception e) {
      Logger.error(e.getMessage());

      result = 500;
    }
    Logger.saveLog();
    return result;
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
      WHERE Id = :subId
      LIMIT 1
    ];

    return sub;
  }

  /**
   * @description Helpler method. Gets Stripe subscription id
   *
   * @return String Stripe subscription Id
   */
  public String getSubscriptionId(StripeWebhookInvoiceWrapper wrapper) {
    String subId = wrapper.data.object_x.lines.data[0]
      .metadata.Salesforce_Subscription_Id;
    return subId;
  }
}
