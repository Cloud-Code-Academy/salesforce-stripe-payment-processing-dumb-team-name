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
private class StripeCheckoutResponseWrapper_Test {

@IsTest
static void testResponseWrapperDeserialization() {
    String jsonResponse = '{"id":"cs_123","objectType":"checkout.session","mode":"subscription","customer":"cus_456","subscription":"sub_789","status":"open","success_url":"https://ok.com","cancel_url":"https://cancel.com","url":"https://checkout.com","metadata":{"key":"value"}}';
    
    StripeCheckoutResponseWrapper resp = (StripeCheckoutResponseWrapper)JSON.deserialize(jsonResponse, StripeCheckoutResponseWrapper.class);
    
    System.assertEquals('cs_123', resp.id);
    System.assertEquals('checkout.session', resp.objectType);
    System.assertEquals('subscription', resp.mode);
    System.assertEquals('cus_456', resp.customer);
    System.assertEquals('sub_789', resp.subscription);
    System.assertEquals('open', resp.status);
    System.assertEquals('https://ok.com', resp.success_url);
    System.assertEquals('https://cancel.com', resp.cancel_url);
    System.assertEquals('https://checkout.com', resp.url);
    System.assertEquals('value', resp.metadata.get('key'));
}
    static void myUnitTest() {
        // TO DO: implement unit test
    }
}