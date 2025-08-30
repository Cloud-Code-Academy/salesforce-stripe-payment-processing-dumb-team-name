/**
 * @description Contains the logic for handling Stripe inbound customer events
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Stripe Inbound Integration
 */

public without sharing class StripeCustomerWebhookStrategy implements IStripeWebhookStrategy {
  /**
   * @description Main method for all inbound customer events
   *
   * @return Integer Http response code
   */
  public Integer handle(String requestBody) {
    Logger.info('Executing customer strategy');

    StripeWebhookCustomerWrapper wrapper = StripeWebhookCustomerWrapper.parse(
      requestBody
    );

    Integer result;

    // Exit if this event is not supported
    if (wrapper.type != 'customer.updated') {
      Logger.error('No support for this strategy');
      return 404;
    }

    result = customerUpdate(wrapper);
    return result;
  }

  /**
   * @description Contains the logic for customer update events
   *
   * @return Integer Http response code
   */
  public Integer customerUpdate(StripeWebhookCustomerWrapper wrapper) {
    String customerId = wrapper.data.object_x.id;

    Stripe_Customer__c customer = [
      SELECT
        Customer_Email__c,
        Customer_Name__c,
        Customer_Phone__c,
        Default_Payment_Method__c,
        Stripe_Customer_ID__c
      FROM Stripe_Customer__c
      WHERE Stripe_Customer_ID__c = :customerId
    ];

    customer.Customer_Email__c = wrapper.data.object_x.email;
    customer.Customer_Name__c = wrapper.data.object_x.name;
    customer.Customer_Phone__c = wrapper.data.object_x.phone;
    customer.Default_Payment_Method__c = wrapper.data.object_x.default_source;

    try {
      update customer;
    } catch (DmlException e) {
      Logger.error(e.getMessage());
      return 422;
    } catch (Exception e) {
      Logger.error(e.getMessage());
      return 500;
    }
    return 204;
  }
}

//TODO: are these logs being saved when the program runs?
//TODO: are these values being return?
