@isTest
private class StripeWebhookTest {
  @isTest
  static void testVerifyStripeSignatureTrue() {
    // Fake body
    String body = '{"id":"evt_test","object":"event"}';
    // Fake secret
    String secret = 'whsec_test123';
    // Fake timestamp
    String timestamp = String.valueOf(DateTime.now().getTime() / 1000); // UNIX seconds
    // Build signed payload string
    String signedPayload = timestamp + '.' + body;

    // Compute expected signature (what Stripe would send as v1)
    Blob key = Blob.valueOf(secret);
    Blob message = Blob.valueOf(signedPayload);
    Blob hash = Crypto.generateMac('HMACSHA256', message, key);
    String expectedSig = EncodingUtil.convertToHex(hash);

    // Build Stripe-Signature header
    String headerValue = 't=' + timestamp + ',v1=' + expectedSig;

    // Call the method under test
    Boolean result = StripeEventsWebhook.verifyStripeSignature(
      body,
      headerValue,
      secret
    );

    System.assertEquals(true, result, 'Signature should validate correctly');
  }
  @isTest
  static void testVerifyStripeSignatureFalse() {
    // Fake body
    String body = '{"id":"evt_test","object":"event"}';
    // Fake secret
    String secret = 'whsec_test123';
    // Wrong header (invalid v1)
    String badHeader = 't=1234567890,v1=abcdef1234567890';
    // Call the method under test
    Boolean result = StripeEventsWebhook.verifyStripeSignature(
      body,
      badHeader,
      secret
    );

    System.assertEquals(false, result, 'Signature should not validate');
  }

  @isTest
  static void testVerifyStripeSignatureNull() {
    // Fake body
    String body = '{"id":"evt_test","object":"event"}';
    // Fake secret
    String secret = 'whsec_test123';
    // Wrong header (invalid v1)
    String nullHeader;
    // Call the method under test
    Boolean result = StripeEventsWebhook.verifyStripeSignature(
      body,
      nullHeader,
      secret
    );

    System.assertEquals(
      false,
      result,
      'Response should be 401 since sigHeader was null. '
    );
  }

  @isTest
  static void testVerifyStripeSignatureMalformedSigHeader() {
    // Fake body
    String body = '{"id":"evt_test","object":"event"}';
    // Fake secret
    String secret = 'whsec_test123';
    // v1 changed to v0
    String malformedHeader = 't=1234567890,v0=abcdef1234567890';
    // Call the method under test
    Boolean result = StripeEventsWebhook.verifyStripeSignature(
      body,
      malformedHeader,
      secret
    );

    System.assertEquals(
      false,
      result,
      'Signature should not validate with a malformed sigHeader'
    );
  }

  // @isTest
  // static void testHandleWebhookPostAuthorized() {
  //   Stripe_Customer__c customer = StripeTestDataFactory.createStripeCustomer(
  //     true
  //   );
  //   String body = StripeWebhookTestFixtures.customerEvents(
  //     customer.Id,
  //     'customer.updated',
  //     customer.Customer_Email__c
  //   );

  //   RestRequest request = new RestRequest();
  //   RestResponse response = new RestResponse();

  //   request.httpMethod = 'POST';
  //   request.requestUri = '/services/apexrest/webhook/stripe';
  //   request.requestBody = Blob.valueOf(body);

  //   String secret = 'whsec_test123';
  //   // Fake timestamp
  //   String timestamp = String.valueOf(DateTime.now().getTime() / 1000); // UNIX seconds
  //   // Build signed payload string
  //   String signedPayload = timestamp + '.' + body;

  //   // Compute expected signature (what Stripe would send as v1)
  //   Blob key = Blob.valueOf(secret);
  //   Blob message = Blob.valueOf(signedPayload);
  //   Blob hash = Crypto.generateMac('HMACSHA256', message, key);
  //   String expectedSig = EncodingUtil.convertToHex(hash);

  //   // Build Stripe-Signature header
  //   String headerValue = 't=' + timestamp + ',v1=' + expectedSig;

  //   request.addHeader('Stripe-Signature', headerValue);

  //   RestContext.request = request;
  //   RestContext.response = response;

  //   test.startTest();
  //   Integer responseCode = StripeEventsWebhook.handleWebhookPost();
  //   test.stopTest();

  //   Assert.areEqual(
  //     201,
  //     responseCode,
  //     'This was a valid request and should return status code 201.'
  //   );
  // }

  @isTest
  static void testHandleWebhookPostInvalidEvent() {
    String body = '{"id":"evt_test","type":"customer.created"}';

    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();

    request.httpMethod = 'POST';
    request.requestUri = '/services/apexrest/webhook/stripe';
    request.requestBody = Blob.valueOf(body);

    String secret = 'whsec_test123';
    // Fake timestamp
    String timestamp = String.valueOf(DateTime.now().getTime() / 1000); // UNIX seconds
    // Build signed payload string
    String signedPayload = timestamp + '.' + body;

    // Compute expected signature (what Stripe would send as v1)
    Blob key = Blob.valueOf(secret);
    Blob message = Blob.valueOf(signedPayload);
    Blob hash = Crypto.generateMac('HMACSHA256', message, key);
    String expectedSig = EncodingUtil.convertToHex(hash);

    // Build Stripe-Signature header
    String headerValue = 't=' + timestamp + ',v1=' + expectedSig;

    request.addHeader('Stripe-Signature', headerValue);

    RestContext.request = request;
    RestContext.response = response;

    Integer responseCode = StripeEventsWebhook.handleWebhookPost();

    Assert.areEqual(
      404,
      responseCode,
      'customer_created is not on the list of events to be handled. It should have return a response code 404.'
    );
  }
  @isTest
  static void testHandleWebhookPostInvalidSignature() {
    String body = '{"id":"evt_test","type":"customer.created"}';

    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();

    request.httpMethod = 'POST';
    request.requestUri = '/services/apexrest/webhook/stripe';
    request.requestBody = Blob.valueOf(body);

    String badHeader = 't=1234567890,v1=abcdef1234567890';

    request.addHeader('Stripe-Signature', badHeader);

    RestContext.request = request;
    RestContext.response = response;

    Integer responseCode = StripeEventsWebhook.handleWebhookPost();

    Assert.areEqual(
      401,
      responseCode,
      'This was an invalid signature and should have returned response code 401.'
    );
  }
}
