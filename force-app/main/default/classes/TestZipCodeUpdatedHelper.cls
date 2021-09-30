@IsTest
private class TestZipCodeUpdatedHelper {
    @IsTest static void TestAccountZipChanged() {
        //Test data setup
        //Create account with given billing postal code, and then try to change it
        Test.startTest();
        Account acct = new Account(Name='Test Account', BillingPostalCode='91000');
        insert acct;
        Contact cnt = new Contact(FirstName='Test', LastName ='Test', accountId=acct.Id);
        insert cnt;
        Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Prospecting', CloseDate = System.Today()+1, AccountId = acct.Id);
        insert opp;
        Id theId;
        Boolean hasPreviousTerr;

        //Perform test
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User usr0 = new User(Alias = 'standt0', Email='standarduser0@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser0jehwuifwibecwi@testorg.com');
		User usr1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1svnakmsñlakdñajskac@testorg.com');
        User usr2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2asvlkajuqbfwjnñsalv@testorg.com');
        insert usr0;
		insert usr1;
        insert usr2;
        Territory__c terr0 = new Territory__c(Name='33600', OwnerId=usr0.Id);
        Territory__c terr1 = new Territory__c(Name='11200', OwnerId=usr1.Id);
        Territory__c terr2 = new Territory__c(Name='11200', OwnerId=usr2.Id);
        insert terr0;
        insert terr1;
        insert terr2;

        acct.BillingPostalCode = '33600';
        update acct;
        acct.BillingPostalCode = '11200';
        update acct;
        System.assertEquals(2, Limits.getEmailInvocations());
        Test.stopTest();

        if(acct.OwnerId == terr1.OwnerId){
            theId = terr1.OwnerId;
        }else if(acct.OwnerId == terr2.OwnerId){
            theId = terr2.OwnerId;
        }

        System.assert(acct.OwnerId == theId);
        System.assert(cnt.OwnerId == theId);
        System.assert(opp.OwnerId == theId);
    }
}
