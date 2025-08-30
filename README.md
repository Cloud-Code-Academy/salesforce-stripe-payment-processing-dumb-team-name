# Salesforce-Stripe Payment Processing Integration
## 🚀 Features

-Instant synchronization for Customer and Subscription data from Salesforce to Stripe
- Trigger-based updates whenever a record changes in Salesforce  
- Queueable Apex implementation for reliable callouts  
- Error handling and logging for failed sync attempts  
- Extensible design to add more fields or functionality later 

## Setup Instructions

### 1. 🏋️‍♀️ Prerequisites
- Salesforce org with API access enabled

- A valid Stripe API Key (test or live, depending on environment)

>[Stripe API References](https://docs.stripe.com/api)

>[Stripe API Keys](https://docs.stripe.com/keys)

>[Stripe Dashboard](https://dashboard.stripe.com/test/dashboard)


### 2. 🛠️ Installation
   1. Clone or pull this repository into your local Salesforce DX / VS Code project  
   2. Deploy metadata to your Salesforce org  
      ```sh
      sfdx force:source:deploy -p force-app

### 3. 🤓 Configuration
   ## Named Credential/ External Credential Permissions
   Configure with your Stripe API key / secret by replacing "INSERT BEARER + YOUR KEY HERE" with your own (do not commit this to source control).

## 🐎 Usage

Once installed and configured, the integration runs automatically:

### Outbound (Salesforce → Stripe)
1. Create or update a record in Salesforce (e.g., Customer or Subscription).
2. The **Trigger** fires, passing the record into the **Handler**.
3. The **Handler** determines if a Stripe sync is required.
4. The **Service Class** prepares the request payload for Stripe.
5. A **Queueable Apex** job is enqueued to make the asynchronous callout.
6. Stripe processes the request and returns a response.

### Inbound (Stripe → Salesforce)
1. Stripe sends an event (e.g., `invoice.payment_failed`, `customer.updated`) to the configured Salesforce **Webhook endpoint**.
2. The **Webhook Controller** receives and validates the request.
3. A **Queueable Apex** job is enqueued to process the webhook event asynchronously.
4. Salesforce records are updated to reflect the latest state from Stripe.

---

### Example Flow
- **Salesforce user** creates/updates a subscription record → Trigger → Handler → Service → Queueable → Stripe.  
- **Stripe** notifies Salesforce of a change → Webhook → Queueable → Salesforce updates record.


## 🥴 Troubleshooting

   1. Verify Object and Field Level Security
>[Field Level Security](https://help.salesforce.com/s/articleView?id=platform.users_profiles_field_perms.htm&type=5)
>[Object Permissions](https://developer.salesforce.com/docs/atlas.en-us.securityImplGuide.meta/securityImplGuide/users_profiles_object_perms.htm)

   2. Confirm Sharing Settings allow access
>[Sharing and Record Access Features](https://help.salesforce.com/s/articleView?id=platform.managing_the_sharing_model.htm&type=5)

   3. Double-check Stripe API Key and External Credential configuration
>[Defining Named & External Credentials](https://help.salesforce.com/s/articleView?id=platform.external_services_define_named_credential.htm&type=5)

   4. Stripe Support
>[Stripe Support](https://support.stripe.com/)

## 🌭 Architecture

Link to the Architecture Diagram


## 💞 Contributing

   Fork the repository and submit pull requests for enhancements or bug fixes

   ## 📨 Questions And/Or Feedback

   [Email Jason Towers](mailto:jasonmtowers@gmail.com) or send Jason a message on [LinkedIn](www.linkedin.com/in/jasonmtowers)
   [Email Jonathan Lyles](jonathan.lyles.linkedin@gmail.com) or send Jonathan a message on [LinkedIn](https://www.linkedin.com/in/jonlyles/)


