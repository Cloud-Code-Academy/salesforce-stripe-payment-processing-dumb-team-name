/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class StripeHttpMock implements HttpCalloutMock {
  private Integer statusCode;
  private String body;
  private Integer counter = 0;

  // Constructor
  public StripeHttpMock(Integer statusCode, String body) {
    this.statusCode = statusCode;
    this.body = body;
  }

  public HTTPResponse respond(HTTPRequest req) {
    counter++;
    HttpResponse res = new HttpResponse();
    res.setStatusCode(200);
    res.setBody(
      '{"id":"cus_test' +
        counter +
        '","email":"test' +
        counter +
        '@example.com","name":"Test User ' +
        counter +
        '"}'
    );
    res.setHeader('Content-Type', 'application/json');
    return res;
  }

  public static StripeHttpMock CustomerCreateSuccess() {
    String body = '{"id":"cus_123456789","object":"customer","email":"test@example.com","name":"Test Customer","phone":"1234567890","metadata":{},"default_source":null,"invoice_settings":{"custom_fields":null,"default_payment_method":null,"footer":null},"created":1749500297,"livemode":false,"description":null,"delinquent":false}';
    return new StripeHttpMock(200, body);
  }

  public static StripeHttpMock CustomerCreateFailure() {
    String body = '{"error":{"message":"The email address provided is invalid.","type":"invalid_request_error","param":"email"}}';
    return new StripeHttpMock(400, body);
  }
  public static StripeHttpMock CustomerUpdateSuccess() {
    String body = '{"id":"cus_test_123","object":"customer","email":"updated@example.com","name":"Updated Customer","phone":"9876543210","metadata":{},"default_source":null,"invoice_settings":{"custom_fields":null,"default_payment_method":null,"footer":null},"created":1749500297,"livemode":false,"description":"Updated test customer","delinquent":false}';
    return new StripeHttpMock(200, body);
  }

  public static StripeHttpMock CustomerUpdateFailure() {
    String body = '{"error":{"message":"The customer ID provided does not exist.","type":"invalid_request_error","param":"id"}}';
    return new StripeHttpMock(404, body);
  }

  public static StripeHttpMock SubscriptionCreateSuccess() {
    String body = '{"id":"sub_test_123","object":"subscription","customer":"cus_test_123","status":"active","items":{"object":"list","data":[{"id":"si_test_123","object":"subscription_item","price":{"id":"price_test_123","object":"price","unit_amount":1000,"currency":"usd","recurring":{"interval":"month","interval_count":1}},"quantity":1}]},"start_date":1749500000,"current_period_start":1749500000,"current_period_end":1752092000,"cancel_at_period_end":false}';
    return new StripeHttpMock(200, body);
  }

  public static StripeHttpMock SubscriptionCreateFailure() {
    String body = '{"error":{"message":"No such price: price_test_123","type":"invalid_request_error","param":"items[0][price]"}}';
    return new StripeHttpMock(400, body);
  }

  public static StripeHttpMock SubscriptionUpdateSuccess() {
    String body = '{"id":"sub_123","object":"subscription","customer":"cus_test_123","status":"active","items":{"object":"list","data":[{"id":"si_test_123","object":"subscription_item","price":{"id":"price_test_123","object":"price","unit_amount":1000,"currency":"usd","recurring":{"interval":"month","interval_count":1}},"quantity":1}]},"start_date":1749500000,"current_period_start":1749500000,"current_period_end":1752092000,"cancel_at_period_end":false}';
    return new StripeHttpMock(200, body);
  }

  public static StripeHttpMock SubscriptionUpdateFailure() {
    String body = '{"error":{"message":"The subscription ID provided does not exist.","type":"invalid_request_error","param":"id"}}';
    return new StripeHttpMock(404, body);
  }

  // Success response for creating a Checkout Session
  public static StripeHttpMock CheckoutSessionCreateSuccess() {
    String body = '{"id":"cs_test_1234567890","object":"checkout.session","amount_total":3300,"currency":"usd","customer":"cus_test_123","payment_status":"paid","status":"complete","subscription":"sub_test_123","url":"https://checkout.stripe.com/pay/cs_test_1234567890"}';
    return new StripeHttpMock(200, body);
  }

  // Failure response for creating a Checkout Session
  public static StripeHttpMock CheckoutSessionCreateFailure() {
    String body = '{"error":{"message":"The price provided does not exist.","type":"invalid_request_error","param":"line_items[0][price]"}}';
    return new StripeHttpMock(400, body);
  }

  // Helper for an error response
  public static StripeHttpMock createErrorResponse() {
    String body = '{"error":{"message":"Invalid request"}}';
    return new StripeHttpMock(400, body);
  }
}
