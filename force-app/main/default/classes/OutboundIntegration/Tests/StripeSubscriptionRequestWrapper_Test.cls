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
private class StripeSubscriptionRequestWrapper_Test {
  @IsTest
  static void testWrapperWithAllValues() {
    Map<String, String> metadata = new Map<String, String>{
      'customer' => 'AcmeCorp',
      'plan' => 'Gold'
    };

    StripeSubscriptionRequestWrapper wrapper = new StripeSubscriptionRequestWrapper(
      'sub_123',
      'si_456',
      'price_789',
      true,
      'always_invoice',
      metadata
    );

    String formEncoded = wrapper.toFormEncoded();

    System.assert(formEncoded.contains('items[0][id]=si_456'));
    System.assert(formEncoded.contains('items[0][price]=price_789'));
    System.assert(formEncoded.contains('cancel_at_period_end=true'));
    System.assert(formEncoded.contains('proration_behavior=always_invoice'));
    System.assert(formEncoded.contains('metadata[customer]=AcmeCorp'));
    System.assert(formEncoded.contains('metadata[plan]=Gold'));
  }

  @IsTest
  static void testWrapperWithNullsAndDefaults() {
    StripeSubscriptionRequestWrapper wrapper = new StripeSubscriptionRequestWrapper(
      'sub_001',
      'si_001',
      'price_001',
      false,
      null,
      null
    );

    // Should default prorateBehavior and create empty metadata map
    System.assertEquals('create_prorations', wrapper.prorateBehavior);
    System.assertNotEquals(null, wrapper.metadata);
    System.assertEquals(0, wrapper.metadata.size());

    String formEncoded = wrapper.toFormEncoded();

    System.assert(formEncoded.contains('items[0][id]=si_001'));
    System.assert(formEncoded.contains('items[0][price]=price_001'));
    System.assert(formEncoded.contains('cancel_at_period_end=false'));
    System.assert(formEncoded.contains('proration_behavior=create_prorations'));
  }

  @IsTest
  static void testWrapperIgnoresBlankMetadata() {
    Map<String, String> metadata = new Map<String, String>{
      'validKey' => 'validValue',
      'blankValue' => '',
      '' => 'someValue'
    };

    StripeSubscriptionRequestWrapper wrapper = new StripeSubscriptionRequestWrapper(
      'sub_002',
      'si_002',
      'price_002',
      true,
      null,
      metadata
    );

    String formEncoded = wrapper.toFormEncoded();

    System.assert(formEncoded.contains('metadata[validKey]=validValue'));
    System.assert(!formEncoded.contains('metadata[blankValue]'));
    System.assert(!formEncoded.contains('metadata[]'));
  }
}
