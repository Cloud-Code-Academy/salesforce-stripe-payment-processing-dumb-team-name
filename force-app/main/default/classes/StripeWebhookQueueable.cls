public with sharing class StripeWebhookQueueable implements Queueable {

    public IStripeWebhookStrategy strategy;
    private String requestBody;
    public Integer responseCode;
    
    public StripeWebhookQueueable(IStripeWebhookStrategy strategy, String requestBody) {

        this.strategy = strategy;
        this.requestBody = requestBody;

    }

    public void execute(QueueableContext qc) {

        this.responseCode = strategy.handle(requestBody);

    }


}