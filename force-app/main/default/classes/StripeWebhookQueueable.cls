public with sharing class StripeWebhookQueueable implements Queueable {

    IStripeWebhookStrategy strategy;
    String requestBody;

    public StripeWebhookQueueable(IStripeWebhookStrategy strategy, String requestBody) {

        this.strategy = strategy;
        this.requestBody = requestBody;

    }

    public void execute(QueueableContext qc) {

        strategy.handle(requestBody);

    } 

}