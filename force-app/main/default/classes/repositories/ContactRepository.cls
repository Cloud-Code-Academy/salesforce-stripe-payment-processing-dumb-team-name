/**
 * @description - This class handles retrieving contact data
 * @author - Jonathan Lyles
 * @date - August 12, 2025
 */
public with sharing class ContactRepository {
    public static List<Contact> getContactsByIds(Set<Id> contactIds){
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id IN :contactIds];
        return contacts;
    }
}