public interface IStripeWebhookStrategy {

    void handle(String requestBody);

}