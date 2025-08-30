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
@IsTest
private class StripeCheckoutRequestWrapper_Test {
  @IsTest
  static void testConstructorAndToFormEncoded() {
    // Arrange
    List<StripeCheckoutRequestWrapper.LineItem> lineItems = new List<StripeCheckoutRequestWrapper.LineItem>{
      new StripeCheckoutRequestWrapper.LineItem('price_123', 2)
    };
    Map<String, String> metadata = new Map<String, String>{
      'key1' => 'value1'
    };
    Map<String, String> subMetadata = new Map<String, String>{
      'subKey' => 'subValue'
    };

    // Act
    StripeCheckoutRequestWrapper wrapper = new StripeCheckoutRequestWrapper(
      'cus_123',
      'subscription',
      'https://success.com',
      'https://cancel.com',
      lineItems,
      metadata,
      'sub_123',
      subMetadata
    );

    String encoded = wrapper.toFormEncoded();

    System.assert(
      encoded.contains('customer=cus_123'),
      'Customer param missing'
    );
    System.assert(encoded.contains('mode=subscription'), 'Mode param missing');
    System.assert(
      encoded.contains('success_url=https%3A%2F%2Fsuccess.com'),
      'Success URL missing'
    );
    System.assert(
      encoded.contains('cancel_url=https%3A%2F%2Fcancel.com'),
      'Cancel URL missing'
    );
    System.assert(
      encoded.contains('line_items[0][price]=price_123'),
      'Line item price missing'
    );
    System.assert(
      encoded.contains('line_items[0][quantity]=2'),
      'Line item qty missing'
    );
    System.assert(
      encoded.contains('metadata[key1]=value1'),
      'Custom metadata missing'
    );
    System.assert(
      encoded.contains('metadata[Salesforce_Subscription_Id]=sub_123'),
      'Injected metadata missing'
    );
    System.assert(
      encoded.contains('payment_method_types[0]=card'),
      'Payment method card missing'
    );
    System.assert(
      encoded.contains('payment_method_types[1]=link'),
      'Payment method link missing'
    );
    System.assert(
      encoded.contains(
        'subscription_data[metadata][Salesforce_Subscription_Id]=sub_123'
      ),
      'Subscription metadata missing'
    );
    System.assert(
      encoded.contains('subscription_data[metadata][subKey]=subValue'),
      'Custom subscription metadata missing'
    );
  }

  @IsTest
  static void testLineItemValidation() {
    Test.startTest();
    // Missing price
    new StripeCheckoutRequestWrapper.LineItem(null, 1);
    // Missing quantity
    new StripeCheckoutRequestWrapper.LineItem('price_456', null);
    Test.stopTest();

    // If Logger writes somewhere, we just make sure no unhandled exception thrown
    System.assert(
      true,
      'LineItem constructor handled blank values without exception'
    );
  }

  @IsTest
  static void testNullMetadataHandled() {
    List<StripeCheckoutRequestWrapper.LineItem> lineItems = new List<StripeCheckoutRequestWrapper.LineItem>{
      new StripeCheckoutRequestWrapper.LineItem('price_789', 1)
    };

    StripeCheckoutRequestWrapper wrapper = new StripeCheckoutRequestWrapper(
      'cus_789',
      'payment',
      'https://ok.com',
      'https://cancel.com',
      lineItems,
      null,
      'sub_789',
      new Map<String, String>()
    );

    String encoded = wrapper.toFormEncoded();

    System.assert(
      encoded.contains('customer=cus_789'),
      'Customer should still be set'
    );
    System.assert(
      encoded.contains('metadata[Salesforce_Subscription_Id]=sub_789'),
      'Subscription Id should be injected into metadata even if null passed in'
    );
  }
}
