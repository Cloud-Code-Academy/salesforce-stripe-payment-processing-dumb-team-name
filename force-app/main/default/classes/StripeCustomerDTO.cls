public class StripeCustomerDTO {
    public String id;        // Stripe customer ID
    public String email;     // Customer's email
    public String name;      // Customer's name

    public StripeCustomerDTO(String email, String name) {
        this.email = email;
        this.name = name;
    }
}