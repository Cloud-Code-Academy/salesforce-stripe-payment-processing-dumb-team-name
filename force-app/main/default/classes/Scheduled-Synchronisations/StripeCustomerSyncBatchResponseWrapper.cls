public with sharing class StripeCustomerSyncBatchResponseWrapper {
  public String id { get; set; }
  public DataWrapper data { get; set; }

  public class DataWrapper {
    public CustomerWrapper object_x { get; set; }
  }

  public class CustomerWrapper {
    public String default_source { get; set; }
  }
}
