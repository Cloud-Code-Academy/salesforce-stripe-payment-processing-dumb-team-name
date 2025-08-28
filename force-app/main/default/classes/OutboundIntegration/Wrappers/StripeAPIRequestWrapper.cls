public with sharing class StripeAPIRequestWrapper {
    public String fullName;
    public String email;

    public StripeAPIRequestWrapper(String fullName, String email) {
        this.fullName = fullName;
         this.email = email;
    }
    public String toUrlEncodedString() {
    return 'name=' + EncodingUtil.urlEncode(fullName, 'UTF-8')
    + '&email=' + EncodingUtil.urlEncode(email, 'UTF-8');
    }
}