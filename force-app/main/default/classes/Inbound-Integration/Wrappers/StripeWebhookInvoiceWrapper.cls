public with sharing class StripeWebhookInvoiceWrapper {
  String id { get; set; }
  String object_x { get; set; }
  Long created { get; set; }
  DataWrapper data { get; set; }
  String type { get; set; }

  public class DataWrapper {
    InvoiceWrapper object_x { get; set; }
  }

  public class InvoiceWrapper {
    String id { get; set; }
    String object_x { get; set; }
    Integer amount_paid { get; set; }
    String currency_x { get; set; }
    String customer { get; set; }
    String invoice_pdf { get; set; }
    LinesWrapper lines { get; set; }
    Integer period_end { get; set; }
    Integer period_start { get; set; }
    String status { get; set; }
  }

  public class LinesWrapper {
    List<LinesData> data { get; set; }
  }

  public class LinesData {
    ParentWrapper parent { get; set; }
  }

  public class ParentWrapper {
    String subscription { get; set; }
  }

  public static StripeWebhookInvoiceWrapper parse(String body) {
    StripeWebhookInvoiceWrapper wrapper = (StripeWebhookInvoiceWrapper) JSON.deserialize(
      body,
      StripeWebhookInvoiceWrapper.class
    );
    return wrapper;
  }
}
