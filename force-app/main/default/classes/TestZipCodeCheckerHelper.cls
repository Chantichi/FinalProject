@IsTest
private class TestZipCodeCheckerHelper{
    @IsTest static void TestMultipleRepAssigned() {
        //Test data setup
        Territory__c zip = new Territory__c(Name='11200');
        insert zip;

        Test.startTest();
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
        User usr3 = new User(Alias = 'standt3', Email='standarduser3@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3jsaajbvahbvjcvahjvv@testorg.com');
        insert usr0;
		insert usr1;
        insert usr2;
        insert usr3;

        try{
            Territory__c terr0 = new Territory__c(Name='11200', OwnerId=usr0.Id);
            Territory__c terr1 = new Territory__c(Name='11200', OwnerId=usr1.Id);
            Territory__c terr2 = new Territory__c(Name='11200', OwnerId=usr2.Id);
            Territory__c terr3 = new Territory__c(Name='11200', OwnerId=usr3.Id);
            insert terr0;
            insert terr1;
            insert terr2;
            insert terr3;
        }catch(Exception e){
            Boolean expectedExceptionThrown;
            if(e.getMessage().contains('Three sales representatives already assigned to this Zip Code')){
                expectedExceptionThrown = true;
            }else{
                expectedExceptionThrown = false;
            }
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        
        Test.stopTest();
    }


    @IsTest static void TerritoryUpdated(){
        Test.startTest();
        //Data creation
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User usr1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1svnakmsñlakdñajskac@testorg.com');
        insert usr1;
        User usr2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2asvlkajuqbfwjnñsalv@testorg.com');
        insert usr2;
        Territory__c terr1 = new Territory__c(Name='11200', OwnerId=usr1.Id);
        insert terr1;
        Account acct = new Account(Name='Test Account', BillingPostalCode='11200', OwnerId=usr1.Id);
        insert acct;
        Contact cnt = new Contact(FirstName='Test', LastName ='Test', accountId=acct.Id, OwnerId=usr1.Id);
        insert cnt;
        Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Prospecting', CloseDate = System.Today()+1, AccountId = acct.Id, OwnerId=usr1.Id);
        insert opp;

        terr1.OwnerId = usr2.Id;
        update terr1;
        Test.stopTest();

        Account newAcct = [SELECT Id, OwnerId FROM Account WHERE Id = :acct.Id];
        Contact newCnt = [SELECT Id, OwnerId FROM Contact WHERE Id = :cnt.Id];
        Opportunity newOpp = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :opp.Id];

        System.assert(newAcct.OwnerId == usr2.Id);
        System.assert(newCnt.OwnerId == usr2.Id);
        System.assert(newOpp.OwnerId == usr2.Id);
    }
}
