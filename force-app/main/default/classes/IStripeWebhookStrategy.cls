public interface IStripeWebhookStrategy {

    Integer handle(String requestBody);

}