/** 
 * @description - Callout strategy for creating a Stripe Customer.
 * @author - Jonathan Lyles and Jason Towers
 * @date - August 12, 2025
*/
public with sharing class CreateCustomerStrategy implements IStripeStrategy {

    private String name;
    private String email;
    private Callout_Setting__mdt callout;

    /**
     * @description - Constructor for instantiating CreateCustomerStrategy
     * @param name - Corresponds to the first and last name of the contact in Salesforce
     * @param email - Corresponds to the contact's email address in Salesforce
     */
    public CreateCustomerStrategy(String name, String email){
        this.name = name;
        this.email = email;
        this.callout = Callout_Setting__mdt.getInstance('Create_Stripe_Customer');
    }

    /**
     * @description - Required to implement IStripeStrategy. This method does the actual callout. It is called by StripeAPIClient
     * @returns - HttpResponse
     */
    public HttpResponse execute() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + callout.Named_Credential__c + callout.Path__c);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        StripeAPIRequestWrapper stripeApiRequestWrapper = new StripeAPIRequestWrapper(
            this.name,
            this.email
            );
            String body = stripeApiRequestWrapper.toUrlEncodedString();
        req.setBody(body);

        return new Http().send(req);
    }
}