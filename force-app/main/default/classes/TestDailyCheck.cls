@IsTest
private class TestDailyCheck {
    @IsTest static void TestDailyCheckRegular() {
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User usr0 = new User(Alias = 'standt0', Email='standarduser0@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser0jehwuifwibecwi@testorg.com');
            insert usr0;
            User usr1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1jasfafsacacxzecwi@testorg.com');
            insert usr1;
            User usr2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2asfafsavacsxzecwi@testorg.com');
            insert usr2;
            User usr3 = new User(Alias = 'standt3', Email='standarduser3@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3asfaxvzzaggjhwi@testorg.com');
            insert usr3;
            User usr4 = new User(Alias = 'standt4', Email='standarduser4@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4akjeoiwkfpowmcwm@testorg.com');
            insert usr4;
            Territory__c terr0 = new Territory__c(Name='11200', OwnerId=usr0.Id);
            insert terr0;
            Territory__c terr1 = new Territory__c(Name='32800', OwnerId=usr1.Id);
            insert terr1;
            Territory__c terr2 = new Territory__c(Name='36800', OwnerId=usr2.Id);
            insert terr2;
            Territory__c terr3 = new Territory__c(Name='36800', OwnerId=usr3.Id);
            insert terr3;
            Territory__c terr4 = new Territory__c(Name='38800', OwnerId=usr4.Id);
            insert terr4;

            Account acct = new Account(Name='Test Account', BillingPostalCode='32800', OwnerId=usr0.Id);
            insert acct;

        Test.startTest();
            DailyCheck myClass = new DailyCheck();
            myClass.execute(null);
        Test.stopTest();

        Account newAcct = [SELECT Id, OwnerId FROM Account WHERE Id = :acct.Id];

        System.assert(newAcct.OwnerId == usr1.Id);
    }

    @IsTest static void TestDailyCheckMultipleAccounts(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User usr0 = new User(Alias = 'standt0', Email='standarduser0@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser0jehwuifwibecwi@testorg.com');
            insert usr0;
            User usr1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1jasfafsacacxzecwi@testorg.com');
            insert usr1;
            User usr2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2asfafsavacsxzecwi@testorg.com');
            insert usr2;
            User usr3 = new User(Alias = 'standt3', Email='standarduser3@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3asfaxvzzaggjhwi@testorg.com');
            insert usr3;
            User usr4 = new User(Alias = 'standt4', Email='standarduser4@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4akjeoiwkfpowmcwm@testorg.com');
            insert usr4;
            Territory__c terr0 = new Territory__c(Name='11200', OwnerId=usr0.Id);
            insert terr0;
            Territory__c terr1 = new Territory__c(Name='32800', OwnerId=usr1.Id);
            insert terr1;
            Territory__c terr2 = new Territory__c(Name='36800', OwnerId=usr2.Id);
            insert terr2;
            Territory__c terr3 = new Territory__c(Name='36800', OwnerId=usr3.Id);
            insert terr3;
            Territory__c terr4 = new Territory__c(Name='36800', OwnerId=usr4.Id);
            insert terr4;

            Account acct = new Account(Name='Test Account', BillingPostalCode='36800', OwnerId=usr0.Id);
            insert acct;

        Test.startTest();
            DailyCheck myClass = new DailyCheck();
            myClass.execute(null);
        Test.stopTest();

        Account newAcct = [SELECT Id, OwnerId FROM Account WHERE Id = :acct.Id];

        if(newAcct.OwnerId == usr2.Id){
            System.assert(newAcct.OwnerId == usr2.Id);
        }else if(newAcct.OwnerId == usr3.Id){
            System.assert(newAcct.OwnerId == usr3.Id);
        }else{
            System.assert(newAcct.OwnerId == usr4.Id);
        }
    }

    @IsTest static void TestDailyCheckOk(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User usr0 = new User(Alias = 'standt0', Email='standarduser0@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser0jehwuifwibecwi@testorg.com');
            insert usr0;
            User usr1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1jasfafsacacxzecwi@testorg.com');
            insert usr1;
            User usr2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2asfafsavacsxzecwi@testorg.com');
            insert usr2;
            User usr3 = new User(Alias = 'standt3', Email='standarduser3@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser3asfaxvzzaggjhwi@testorg.com');
            insert usr3;
            User usr4 = new User(Alias = 'standt4', Email='standarduser4@testorg.com', 
					EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
					LocaleSidKey='en_US', ProfileId = p.Id, 
					TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4akjeoiwkfpowmcwm@testorg.com');
            insert usr4;
            Territory__c terr0 = new Territory__c(Name='11200', OwnerId=usr0.Id);
            insert terr0;
            Territory__c terr1 = new Territory__c(Name='32800', OwnerId=usr1.Id);
            insert terr1;
            Territory__c terr2 = new Territory__c(Name='36800', OwnerId=usr2.Id);
            insert terr2;
            Territory__c terr3 = new Territory__c(Name='36800', OwnerId=usr3.Id);
            insert terr3;
            Territory__c terr4 = new Territory__c(Name='36800', OwnerId=usr4.Id);
            insert terr4;

            Account acct = new Account(Name='Test Account', BillingPostalCode='11200', OwnerId=usr0.Id);
            insert acct;

        Test.startTest();
            DailyCheck myClass = new DailyCheck();
            myClass.execute(null);
        Test.stopTest();

        Account newAcct = [SELECT Id, OwnerId FROM Account WHERE Id = :acct.Id];

        System.assert(newAcct.OwnerId == usr0.Id);
    }

}