/**
 * Unit tests for StripeAPIRequestWrapper
 * Testing library/framework: Salesforce Apex built-in test framework (@IsTest).
 * 
 * This suite focuses on:
 *  - Constructor field assignments
 *  - URL encoding behavior for:
 *      - Typical inputs (spaces, '+' and '@')
 *      - Special characters
 *      - Empty strings
 *      - Null values
 * 
 * Naming: Descriptive test names that clearly communicate purpose.
 * Conventions: Class-level @IsTest with SeeAllData=false; pure function testing with explicit assertions.
 */
@IsTest(SeeAllData=false)
private class StripeAPIRequestWrapper_Test {

    @IsTest
    static void constructor_setsFields_asProvided() {
        // Arrange
        String name = 'Alice Example';
        String email = 'alice@example.com';

        // Act
        StripeAPIRequestWrapper wrapper = new StripeAPIRequestWrapper(name, email);

        // Assert
        System.assertEquals(name, wrapper.fullName, 'Constructor should assign fullName correctly.');
        System.assertEquals(email, wrapper.email, 'Constructor should assign email correctly.');
    }

    @IsTest
    static void toUrlEncodedString_encodesSpacesAndPlusAndAtSign() {
        // Arrange
        String name = 'John Doe'; // space should become '+'
        String email = 'john+test@example.com'; // '+' -> %2B and '@' -> %40
        StripeAPIRequestWrapper wrapper = new StripeAPIRequestWrapper(name, email);

        // Act
        String actual = wrapper.toUrlEncodedString();

        // Assert
        String expected = 'name=' + EncodingUtil.urlEncode(name, 'UTF-8')
                        + '&email=' + EncodingUtil.urlEncode(email, 'UTF-8');
        System.assertNotEquals(null, actual, 'Encoded string should not be null.');
        System.assertEquals(expected, actual, 'Should properly encode spaces, plus sign, and at sign.');
    }

    @IsTest
    static void toUrlEncodedString_handlesEmptyStrings() {
        // Arrange
        String name = '';
        String email = '';
        StripeAPIRequestWrapper wrapper = new StripeAPIRequestWrapper(name, email);

        // Act
        String actual = wrapper.toUrlEncodedString();

        // Assert
        String expected = 'name=' + EncodingUtil.urlEncode(name, 'UTF-8')
                        + '&email=' + EncodingUtil.urlEncode(email, 'UTF-8');
        System.assertEquals(expected, actual, 'Empty inputs should be preserved and encoded as empty.');
    }

    @IsTest
    static void toUrlEncodedString_handlesNullsGracefully() {
        // Arrange
        String name = null;
        String email = null;
        StripeAPIRequestWrapper wrapper = new StripeAPIRequestWrapper(name, email);

        // Act
        String actual = wrapper.toUrlEncodedString();

        // Assert
        // Replicate wrapper logic using the platform’s EncodingUtil to derive expected behavior for nulls.
        String expected = 'name=' + EncodingUtil.urlEncode(name, 'UTF-8')
                        + '&email=' + EncodingUtil.urlEncode(email, 'UTF-8');
        // Note: String concatenation with null in Apex yields 'null' in the final string.
        System.assertEquals(expected, actual, 'Null inputs should be handled consistently with EncodingUtil.urlEncode behavior.');
    }

    @IsTest
    static void toUrlEncodedString_encodesWideRangeOfSpecialCharacters() {
        // Arrange
        String name = 'A&B=C/D?E:F;G H|I@J!K$L*M(N)O_P+Q,R.S~T`U"V\'W';
        String email = 'user.name+tag-123@example-domain.com';
        StripeAPIRequestWrapper wrapper = new StripeAPIRequestWrapper(name, email);

        // Act
        String actual = wrapper.toUrlEncodedString();

        // Assert
        String expected = 'name=' + EncodingUtil.urlEncode(name, 'UTF-8')
                        + '&email=' + EncodingUtil.urlEncode(email, 'UTF-8');
        System.assertEquals(expected, actual, 'All special characters should be correctly URL-encoded.');
    }

    @IsTest
    static void toUrlEncodedString_isDeterministicAcrossMultipleCalls() {
        // Arrange
        String name = 'Repeat Me';
        String email = 'repeat.me@example.com';
        StripeAPIRequestWrapper wrapper = new StripeAPIRequestWrapper(name, email);

        // Act
        String first = wrapper.toUrlEncodedString();
        String second = wrapper.toUrlEncodedString();

        // Assert
        System.assertEquals(first, second, 'Calling the method multiple times should yield identical results.');
    }
}