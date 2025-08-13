// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// Callout_Setting__mdt config = Callout_Setting__mdt.getInstance('Create_Stripe_Customer');
// System.debug(config.path__c);

// CreateCustomerStrategy createCustomer = new CreateCustomerStrategy('John McTestFace', 'mctestface@gmail.com');
// StripeApiClient createClient = new StripeApiClient(createCustomer);
// HttpResponse response = createClient.run();
// System.debug(response.getBody());


Contact testCon = new Contact();
testCon.FirstName = 'Bob6';
testCon.LastName = 'TestFace7';
testCon.Email = 'mctest@test.718';
insert TestCon;