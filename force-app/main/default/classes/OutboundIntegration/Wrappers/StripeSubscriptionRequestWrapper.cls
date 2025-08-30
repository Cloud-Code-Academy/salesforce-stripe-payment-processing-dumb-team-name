public with sharing class StripeSubscriptionRequestWrapper {
  public String subscriptionId;
  public String subscriptionItemId;
  public String newPriceId;
  public Boolean cancelAtPeriodEnd;
  public String prorateBehavior;
  public Map<String, String> metadata;

  public StripeSubscriptionRequestWrapper(
    String subscriptionId,
    String subscriptionItemId,
    String newPriceId,
    Boolean cancelAtPeriodEnd,
    String prorateBehavior,
    Map<String, String> metadata
  ) {
    this.subscriptionId = subscriptionId;
    this.subscriptionItemId = subscriptionItemId;
    this.newPriceId = newPriceId;
    this.cancelAtPeriodEnd = cancelAtPeriodEnd;
    this.prorateBehavior = (prorateBehavior == null)
      ? 'create_prorations'
      : prorateBehavior;
    this.metadata = metadata != null ? metadata : new Map<String, String>();
  }
  public String toFormEncoded() {
    List<String> params = new List<String>();

    // Subscription item update
    params.add(
      'items[0][id]=' + EncodingUtil.urlEncode(subscriptionItemId, 'UTF-8')
    );
    params.add(
      'items[0][price]=' + EncodingUtil.urlEncode(newPriceId, 'UTF-8')
    );

    // Cancellation and proration
    params.add('cancel_at_period_end=' + String.valueOf(cancelAtPeriodEnd));
    params.add(
      'proration_behavior=' + EncodingUtil.urlEncode(prorateBehavior, 'UTF-8')
    );

    // Metadata
    for (String key : metadata.keySet()) {
      String value = metadata.get(key);
      if (String.isNotBlank(key) && String.isNotBlank(value)) {
        params.add(
          'metadata[' +
            EncodingUtil.urlEncode(key, 'UTF-8') +
            ']=' +
            EncodingUtil.urlEncode(value, 'UTF-8')
        );
      }
    }

    return String.join(params, '&');
  }
}
