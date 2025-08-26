/**
 * @description Strategy interface for handling Stripe webhook events. This
 * interface is intended to support the Strategy Pattern, allowing different event
 * handlers to be dynamically selected and executed based on the incoming Stripe webhook event type.
 *
 * Implementations of this interface should:
 *  - Parse the {@code requestBody} payload received from Stripe.
 *  - Process the webhook event according to its type.
 *  - Return an {@code Integer} status code representing the result of the handling
 *
 * @author Jonathan Lyles
 * @date August 26, 2025
 */
public interface IStripeWebhookStrategy {
  Integer handle(String requestBody);
}
