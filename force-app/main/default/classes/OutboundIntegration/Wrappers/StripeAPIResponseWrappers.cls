public with sharing class StripeAPIResponseWrappers {
  //     {
  //   "id": "cus_SpLNkcKMswwoBy",
  //   "object": "customer",
  //   "address": null,
  //   "balance": 0,
  //   "created": 1754622586,
  //   "currency": null,
  //   "default_source": null,
  //   "delinquent": false,
  //   "description": null,
  //   "discount": null,
  //   "email": "jasonmtowers@gmail.com",
  //   "invoice_prefix": "FRUGU9TA",
  //   "invoice_settings": {
  //     "custom_fields": null,
  //     "default_payment_method": null,
  //     "footer": null,
  //     "rendering_options": null
  //   },
  //   "livemode": false,
  //   "metadata": {},
  //   "name": "Jason Towers",
  //   "next_invoice_sequence": 1,
  //   "phone": null,
  //   "preferred_locales": [],
  //   "shipping": null,
  //   "tax_exempt": "none",
  //   "test_clock": null
  // }
  public String id { get; set; }
  public String objectType { get; set; } //object is a reserved word
  public Address address { get; set; }
  public Integer balance { get; set; }
  public String stripeCurrency { get; set; } // currency is a reserved word}
  public String default_source { get; set; }
  public Boolean delinquent { get; set; }
  public String description { get; set; }
  public String discount { get; set; }
  public String email { get; set; }
  public String invoice_prefix { get; set; }
  public InvoiceSettings invoice_settings { get; set; }
  public Boolean livemode { get; set; }
  public Map<String, String> metadata { get; set; }
  public String name { get; set; }
  public Integer next_invoice_sequence { get; set; }
  public String phone { get; set; }
  public List<String> preferred_locales { get; set; }
  public Shipping shipping { get; set; }
  public String tax_exempt { get; set; }
  public String test_clock { get; set; }

  public class Address {
    public String city { get; set; }
    public String country { get; set; }
    public String line1 { get; set; }
    public String line2 { get; set; }
    public String postal_code { get; set; }
  }
  public class InvoiceSettings {
    public List<CustomField> custom_fields { get; set; }
    public String default_payment_method { get; set; }
    public String footer { get; set; }
    public Object rendering_options { get; set; }
  }
  public class CustomField {
    public String name;
    public String value;
  }

  public class Shipping {
    public Address address { get; set; }
    public String name { get; set; }
    public String phone { get; set; }
  }

  public static StripeAPIResponseWrappers parse(String jsonString) {
    StripeAPIResponseWrappers res = (StripeAPIResponseWrappers) JSON.deserialize(
      jsonString,
      StripeAPIResponseWrappers.class
    );
    JSONParser parser = JSON.createParser(jsonString);
    while (parser.nextToken() != null) {
      if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
        String fieldName = parser.getText();
        parser.nextToken();
        if (fieldName == 'object') {
          res.objectType = parser.getText();
        } else if (fieldName == 'currency') {
          res.stripeCurrency = parser.getText();
        }
      }
    }
    return res;
  }
}
