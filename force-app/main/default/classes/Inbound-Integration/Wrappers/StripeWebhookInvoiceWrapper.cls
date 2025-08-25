public with sharing class StripeWebhookInvoiceWrapper {
  public String id { get; set; }
  public String object_x { get; set; }
  public Long created { get; set; }
  public DataWrapper data { get; set; }
  public String type { get; set; }

  public class DataWrapper {
    public InvoiceWrapper object_x { get; set; }
  }

  public class InvoiceWrapper {
    public String id { get; set; }
    public String object_x { get; set; }
    public Integer amount_paid { get; set; }
    public String currency_x { get; set; }
    public String customer { get; set; }
    public String invoice_pdf { get; set; }
    public LinesWrapper lines { get; set; }
    public Integer period_end { get; set; }
    public Integer period_start { get; set; }
    public String status { get; set; }
  }

  public class LinesWrapper {
    public List<LinesData> data { get; set; }
  }

  public class LinesData {
    public ParentWrapper parent { get; set; }
  }

  public class ParentWrapper {
    public InvoiceItemDetails invoice_item_details { get; set; }
  }

  public class InvoiceItemDetails {
    public String subscription { get; set; }
  }

  public static StripeWebhookInvoiceWrapper parse(String body) {
    StripeWebhookInvoiceWrapper wrapper = (StripeWebhookInvoiceWrapper) JSON.deserialize(
      body,
      StripeWebhookInvoiceWrapper.class
    );
    return wrapper;
  }
}
