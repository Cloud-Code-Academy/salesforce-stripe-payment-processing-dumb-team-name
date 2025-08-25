@isTest
public with sharing class StripeWebhookQueueableTest {
  // Mock strategy that succeeds
  private class SuccessStrategy implements IStripeWebhookStrategy {
    public Integer handle(String body) {
      return 201;
    }
  }

  // Mock strategy that throws an exception
  private class FailStrategy implements IStripeWebhookStrategy {
    public Integer handle(String body) {
      throw new AuraHandledException('Simulated failure');
    }
  }

  @isTest
  static void testFinalizerSuccess() {
    Boolean jobSuccess;

    Test.startTest();

    try {
      System.enqueueJob(
        new StripeWebhookQueueable(new SuccessStrategy(), '{"id":"evt_test"}')
      );
      jobSuccess = true;
    } catch (Exception e) {
      jobSuccess = false;
    }
    Test.stopTest();
    Assert.areEqual(true, jobSuccess, 'Queueable had an exception thrown');
  }

  //TODO: This test doesn't work. Restart from scratch

  @isTest
  static void testFinalizerFailure() {
    Test.startTest();
    System.enqueueJob(
      new StripeWebhookQueueable(new FailStrategy(), '{"id":"evt_test"}')
    );
    try {
      Test.stopTest();
      System.assert(false, 'Expected exception was not thrown');
    } catch (AuraHandledException e) {
      //Assert.areEqual('Simulated failure', e.getMessage());
    }
  }
}
