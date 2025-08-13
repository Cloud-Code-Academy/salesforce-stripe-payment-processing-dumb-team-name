/**
 * @description - This class receives and runs the callout strategy
 * @date - August 12, 2025
 * @author - Jonathan Lyles
 */
public with sharing class StripeAPIClient {
    
    private IStripeStrategy strategy;

    public StripeAPIClient(IStripeStrategy strategy) {
        this.strategy = strategy;
    }

    public HttpResponse run(){
        return strategy.execute();
    }

}