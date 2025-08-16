public interface IStripeClient {
    void syncContacts(Map<Id, Contact> contacts);
}