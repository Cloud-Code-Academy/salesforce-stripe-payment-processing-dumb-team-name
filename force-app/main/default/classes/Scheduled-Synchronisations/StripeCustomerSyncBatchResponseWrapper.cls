public with sharing class StripeCustomerSyncBatchResponseWrapper {
  public String id { get; set; }
  public InvoiceSettingsWrapper invoice_settings { get; set; }

  public class InvoiceSettingsWrapper {
    public String default_payment_method { get; set; }
  }
}
