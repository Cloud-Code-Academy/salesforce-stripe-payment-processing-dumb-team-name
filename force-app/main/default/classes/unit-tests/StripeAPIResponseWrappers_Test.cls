@IsTest
private class StripeAPIResponseWrappers_Test {
    // Utility: sample full JSON resembling Stripe "customer" response with common fields
    private static String buildSampleCustomerJson() {
        return '{' +
            '"id":"cus_12345",' +
            '"object":"customer",' +
            '"address":{' +
                '"city":"Austin",' +
                '"country":"US",' +
                '"line1":"123 Main St",' +
                '"line2":"Apt 4",' +
                '"postal_code":"73301"' +
            '},' +
            '"balance":0,' +
            '"created":1754622586,' +
            '"currency":"usd",' +
            '"default_source":null,' +
            '"delinquent":false,' +
            '"description":"Test customer",' +
            '"discount":null,' +
            '"email":"test@example.com",' +
            '"invoice_prefix":"ABC123",' +
            '"invoice_settings":{' +
                '"custom_fields":[{"name":"cf1","value":"val1"},{"name":"cf2","value":"val2"}],' +
                '"default_payment_method":"pm_abc",' +
                '"footer":"Thanks!",' +
                '"rendering_options":null' +
            '},' +
            '"livemode":false,' +
            '"metadata":{"tier":"gold","region":"NA"},' +
            '"name":"Testy McTestface",' +
            '"next_invoice_sequence":7,' +
            '"phone":"+15555550123",' +
            '"preferred_locales":["en","es"],' +
            '"shipping":{' +
                '"address":{' +
                    '"city":"Dallas",' +
                    '"country":"US",' +
                    '"line1":"987 Elm",' +
                    '"line2":null,' +
                    '"postal_code":"75001"' +
                '},' +
                '"name":"Ship To Name",' +
                '"phone":"+15555550987"' +
            '},' +
            '"tax_exempt":"none",' +
            '"test_clock":null' +
        '}';
    }

    @IsTest
    static void parse_setsReservedWordMappings_whenTopLevelObjectAndCurrencyPresent() {
        // Arrange
        String jsonString = buildSampleCustomerJson();

        // Act
        StripeAPIResponseWrappers result = StripeAPIResponseWrappers.parse(jsonString);

        // Assert - verify mapping of reserved words via parser
        System.assertNotEquals(null, result, 'parse should return a non-null wrapper');
        System.assertEquals('cus_12345', result.id, 'id should deserialize from JSON');
        System.assertEquals('customer', result.objectType, 'objectType should be set from top-level "object" field');
        System.assertEquals('usd', result.stripeCurrency, 'stripeCurrency should be set from top-level "currency" field');

        // Assert - verify a sampling of other fields populated by JSON.deserialize
        System.assertEquals(false, result.delinquent, 'delinquent should map from JSON');
        System.assertEquals('Test customer', result.description, 'description should map from JSON');
        System.assertEquals('test@example.com', result.email, 'email should map from JSON');
        System.assertEquals('ABC123', result.invoice_prefix, 'invoice_prefix should map from JSON');
        System.assertEquals(false, result.livemode, 'livemode should map from JSON');
        System.assertEquals('Testy McTestface', result.name, 'name should map from JSON');
        System.assertEquals(7, result.next_invoice_sequence, 'next_invoice_sequence should map from JSON');
        System.assertEquals('+15555550123', result.phone, 'phone should map from JSON');
        System.assertEquals('none', result.tax_exempt, 'tax_exempt should map from JSON');

        // Metadata
        System.assertNotEquals(null, result.metadata, 'metadata should be deserialized to a Map<String,String>');
        System.assertEquals('gold', result.metadata.get('tier'), 'metadata.tier should be present');
        System.assertEquals('NA', result.metadata.get('region'), 'metadata.region should be present');

        // Preferred locales
        System.assertNotEquals(null, result.preferred_locales, 'preferred_locales list should not be null');
        System.assertEquals(2, result.preferred_locales.size(), 'preferred_locales should contain two entries');
        System.assertEquals('en', result.preferred_locales[0], 'preferred_locales[0] should equal "en"');
        System.assertEquals('es', result.preferred_locales[1], 'preferred_locales[1] should equal "es"');

        // Address
        System.assertNotEquals(null, result.address, 'address should be present');
        System.assertEquals('Austin', result.address.city);
        System.assertEquals('US', result.address.country);
        System.assertEquals('123 Main St', result.address.line1);
        System.assertEquals('Apt 4', result.address.line2);
        System.assertEquals('73301', result.address.postal_code);

        // Shipping + nested address
        System.assertNotEquals(null, result.shipping, 'shipping should be present');
        System.assertEquals('Ship To Name', result.shipping.name);
        System.assertEquals('+15555550987', result.shipping.phone);
        System.assertNotEquals(null, result.shipping.address, 'shipping.address should be present');
        System.assertEquals('Dallas', result.shipping.address.city);
        System.assertEquals('US', result.shipping.address.country);
        System.assertEquals('987 Elm', result.shipping.address.line1);
        System.assertEquals(null, result.shipping.address.line2);
        System.assertEquals('75001', result.shipping.address.postal_code);

        // Invoice settings
        System.assertNotEquals(null, result.invoice_settings, 'invoice_settings should be present');
        System.assertEquals('pm_abc', result.invoice_settings.default_payment_method);
        System.assertEquals('Thanks!', result.invoice_settings.footer);

        // Custom fields
        System.assertNotEquals(null, result.invoice_settings.custom_fields, 'invoice_settings.custom_fields should be present');
        System.assertEquals(2, result.invoice_settings.custom_fields.size(), 'Should deserialize two custom_fields entries');
        System.assertEquals('cf1', result.invoice_settings.custom_fields[0].name);
        System.assertEquals('val1', result.invoice_settings.custom_fields[0].value);
        System.assertEquals('cf2', result.invoice_settings.custom_fields[1].name);
        System.assertEquals('val2', result.invoice_settings.custom_fields[1].value);
    }

    @IsTest
    static void parse_handlesNullables_andLeavesReservedMappingsNullWhenMissing() {
        // Arrange: Exclude top-level 'object' and 'currency', set many nulls
        String jsonString =
            '{' +
                '"id":"cus_missing",' +
                // no "object" here
                '"address":null,' +
                '"balance":-10,' + // negative balance edge case
                // no "currency" here
                '"default_source":null,' +
                '"delinquent":true,' +
                '"description":null,' +
                '"discount":null,' +
                '"email":null,' +
                '"invoice_prefix":null,' +
                '"invoice_settings":{' +
                    '"custom_fields":null,' +
                    '"default_payment_method":null,' +
                    '"footer":null,' +
                    '"rendering_options":null' +
                '},' +
                '"livemode":false,' +
                '"metadata":{},' +
                '"name":null,' +
                '"next_invoice_sequence":0,' +
                '"phone":null,' +
                '"preferred_locales":[],' +
                '"shipping":null,' +
                '"tax_exempt":"none",' +
                '"test_clock":null' +
            '}';

        // Act
        StripeAPIResponseWrappers result = StripeAPIResponseWrappers.parse(jsonString);

        // Assert reserved-word mapping should remain null since not present
        System.assertEquals(null, result.objectType, 'objectType should be null when "object" not present');
        System.assertEquals(null, result.stripeCurrency, 'stripeCurrency should be null when "currency" not present');

        // Assert nullables and edge values
        System.assertEquals('cus_missing', result.id);
        System.assertEquals(null, result.address, 'address should be null');
        System.assertEquals(-10, result.balance, 'balance should support negative value');
        System.assertEquals(true, result.delinquent, 'should map true delinquent');
        System.assertEquals(null, result.description);
        System.assertEquals(null, result.discount);
        System.assertEquals(null, result.email);
        System.assertEquals(null, result.invoice_prefix);
        System.assertNotEquals(null, result.invoice_settings, 'invoice_settings should be non-null object');
        System.assertEquals(null, result.invoice_settings.custom_fields, 'custom_fields can be null');
        System.assertEquals(null, result.invoice_settings.default_payment_method);
        System.assertEquals(null, result.invoice_settings.footer);
        System.assertEquals(false, result.livemode);
        System.assertNotEquals(null, result.metadata, 'metadata map should not be null when {}');
        System.assertEquals(0, result.metadata.size(), 'empty metadata should deserialize to empty map');
        System.assertEquals(null, result.name);
        System.assertEquals(0, result.next_invoice_sequence);
        System.assertEquals(null, result.phone);
        System.assertNotEquals(null, result.preferred_locales, 'preferred_locales should be non-null even if empty');
        System.assertEquals(0, result.preferred_locales.size(), 'preferred_locales should be empty list');
        System.assertEquals(null, result.shipping);
        System.assertEquals('none', result.tax_exempt);
        System.assertEquals(null, result.test_clock);
    }

    @IsTest
    static void parse_throwsJSONException_onInvalidJson() {
        // Arrange
        String invalidJson = '{ "id": "cus_broken", '; // deliberately malformed
        Boolean threw = false;

        // Act + Assert
        try {
            StripeAPIResponseWrappers.parse(invalidJson);
        } catch (System.JSONException e) {
            threw = true;
            System.assert(e.getMessage() != null && e.getMessage().contains('Unexpected end of input'),
                'Expected a JSON parse error for malformed input.');
        }
        System.assert(threw, 'parse should throw a System.JSONException for invalid JSON input');
    }

    @IsTest
    static void parse_handlesNullCurrencyValue_setsStripeCurrencyNull() {
        // Arrange: include currency with explicit null
        String jsonString =
            '{' +
                '"id":"cus_nullcurrency",' +
                '"object":"customer",' +
                '"currency":null' +
            '}';

        // Act
        StripeAPIResponseWrappers result = StripeAPIResponseWrappers.parse(jsonString);

        // Assert
        System.assertEquals('customer', result.objectType, 'objectType should be set from "object"');
        System.assertEquals(null, result.stripeCurrency, 'stripeCurrency should be null when currency is null');
    }

    @IsTest
    static void parse_doesNotCrash_withAdditionalUnknownFields() {
        // Arrange: Add unknown field
        String jsonString =
            '{' +
                '"id":"cus_extra",' +
                '"object":"customer",' +
                '"currency":"eur",' +
                '"unknown_field":"some_value",' +
                '"another_unknown":{"nested":true}' +
            '}';

        // Act
        StripeAPIResponseWrappers result = StripeAPIResponseWrappers.parse(jsonString);

        // Assert: Should ignore unknown fields gracefully
        System.assertEquals('cus_extra', result.id);
        System.assertEquals('customer', result.objectType);
        System.assertEquals('eur', result.stripeCurrency);
    }
}