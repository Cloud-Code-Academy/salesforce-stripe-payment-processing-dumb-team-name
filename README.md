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

      [Stripe API References](https://docs.stripe.com/api)

      [Stripe API Keys](https://docs.stripe.com/keys)

      [Stripe Dashboard](https://dashboard.stripe.com/test/dashboard)


### 2. 🛠️ Installation
   1. Clone or pull this repository into your local Salesforce DX / VS Code project  
   2. Deploy metadata to your Salesforce org  
      ```sh
      sfdx force:source:deploy -p force-app

### 3. 🤓 Configuration
   ## Named Credential/ External Credential Permissions
   Setup → External Credentials → New

   Name: STRIPE_EXTERNAL_CREDENTIAL

   Configure with your Stripe API key / secret by replacing "INSERT BEARER + YOUR KEY HERE" with your own (do not commit this to source control).

## 🐎 Usage

## 🥴 Troubleshooting

   1. Verify Object and Field Level Security

   2. Confirm Sharing Settings allow access

   3. Double-check Stripe API Key and External Credential configuration

## 🌭 Architecture

   Trigger – fires on Salesforce record creation and changes

   Handler – handles business logic and decides what needs to happen

   Service class – contains reusable logic for preparing callouts / processing data

   Queueable Apex – performs the actual asynchronous callout to Stripe

## 💞 Contributing

   Fork the repository and submit pull requests for enhancements or bug fixes

   ## 📨 Questions And/Or Feedback

   [Email Me](mailto:jasonmtowers@gmail.com) or send me a message on [LinkedIn](www.linkedin.com/in/jasonmtowers)


