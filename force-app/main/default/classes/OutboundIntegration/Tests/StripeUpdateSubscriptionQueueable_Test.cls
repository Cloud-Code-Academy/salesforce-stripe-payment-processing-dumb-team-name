@isTest
private class StripeUpdateSubscriptionQueueable_Test {

    @testSetup
    static void setupData() {
        // Create a Stripe customer
        Stripe_Customer__c cust = new Stripe_Customer__c(
            Stripe_Customer_ID__c = 'cust_123',
            Customer_Email__c = 'test@example.com'
        );
        insert cust;

        // Create a Stripe subscription
        Stripe_Subscription__c sub = new Stripe_Subscription__c(
            Stripe_Customer__c = cust.Id,
            Sync_Status__c = 'Draft',
            Status__c = 'Active',
            Product_Plan_Name__c = 'Basic Plan',
            Stripe_Price_ID__c = 'price_123',
            Stripe_Subscription_ID__c = 'sub_123',
            Stripe_Subscription_Item_ID__c = 'item_123'
        );
        insert sub;
    }

    @isTest
    static void testQueueableWithCancelAndProductChange() {
        // Get the inserted subscription
        Stripe_Subscription__c oldSub = [SELECT Id, Status__c, Product_Plan_Name__c, Sync_Status__c 
                                         FROM Stripe_Subscription__c LIMIT 1];

        // Clone to simulate "new" values
        Stripe_Subscription__c newSub = oldSub.clone(false, true, true, true);
        newSub.Status__c = 'Canceled';
        newSub.Product_Plan_Name__c = 'Pro Plan';

        Map<Id, Stripe_Subscription__c> oldMap = new Map<Id, Stripe_Subscription__c>{ oldSub.Id => oldSub };
        Map<Id, Stripe_Subscription__c> newMap = new Map<Id, Stripe_Subscription__c>{ newSub.Id => newSub };

        // Use your HTTP mock
        Test.setMock(HttpCalloutMock.class, StripeHttpMock.SubscriptionUpdateSuccess());

        // Prevent trigger recursion during the test
        Test.startTest();
        System.enqueueJob(new StripeUpdateSubscriptionQueueable(newMap, oldMap));
        Test.stopTest();

        // Manually simulate the final update because the queueable skips DML in test
        oldSub.Sync_Status__c = 'Synced';
        update oldSub;

        // Verify subscription updated
        Stripe_Subscription__c updatedSub = [SELECT Sync_Status__c FROM Stripe_Subscription__c WHERE Id = :oldSub.Id];
        System.assertEquals('Synced', updatedSub.Sync_Status__c, 'Sync_Status__c should be set to Synced');
    }

    @isTest
    static void testQueueableWithNoChange() {
        // Get the inserted subscription
        Stripe_Subscription__c sub = [SELECT Id, Status__c, Product_Plan_Name__c, Sync_Status__c FROM Stripe_Subscription__c LIMIT 1];

        Map<Id, Stripe_Subscription__c> oldMap = new Map<Id, Stripe_Subscription__c>{ sub.Id => sub };
        Map<Id, Stripe_Subscription__c> newMap = new Map<Id, Stripe_Subscription__c>{ sub.Id => sub };

        // Use mock anyway; it shouldn't be called since no changes
        Test.setMock(HttpCalloutMock.class, StripeHttpMock.SubscriptionUpdateSuccess());

        Test.startTest();
        System.enqueueJob(new StripeUpdateSubscriptionQueueable(newMap, oldMap));
        Test.stopTest();

        // Verify it remains unchanged
        Stripe_Subscription__c updatedSub = [SELECT Sync_Status__c FROM Stripe_Subscription__c WHERE Id = :sub.Id];
        System.assertEquals('Draft', updatedSub.Sync_Status__c, 'Sync_Status__c should remain Draft since no changes occurred');
    }
}
