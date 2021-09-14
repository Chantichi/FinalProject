public with sharing class ZipCodeUpdatedHelper {
    public ZipCodeUpdatedHelper(List<Account> AccToWork) {
        List<Account> AccOk = new List<Account>();
        List<Contact> ContactOk = new List<Contact>();
        List<Opportunity> OppOk = new List<Opportunity>();
        for(Account AccInWork : AccToWork){
            //Change the Account Owner to the sales representative assigned to the new zip code
            AccInWork.OwnerId = [SELECT OwnerId FROM Territory__c WHERE Territory__c.Name = AccInWork.BillingPostalCode];
            AccOk.add(AccInWork);
            //Change the Owner field of all the Account’s Contacts to the same sales rep
            ContactInWork = [SELECT Id FROM Contact WHERE Contact.AccountId = AccInWork.Id];
            ContactInWork.OwnerId = [SELECT OwnerId FROM Territory__c WHERE Territory__c.Name = AccInWork.BillingPostalCode];
            ContactOk.add(ContactInWork);
            //Change the Owner field of all the Account’s Open Opportunities to the same sales rep
            OppInWork = [SELECT Id FROM Opportunity WHERE IsClosed = False AND Opportunity.AccountId = AccInWork.Id];
            OppInWork.OwnerId = [SELECT OwnerId FROM Territory__c WHERE Territory__c.Name = AccInWork.BillingPostalCode];
            OppOk.add(OppInWork);
        }
        update AccOk;
        update ContactOk;
        update OppOk;
    }
}
