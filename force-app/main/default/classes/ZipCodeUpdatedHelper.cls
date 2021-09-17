public without sharing class ZipCodeUpdatedHelper {
    public static void InitialCheck(List<Account> AccToWork, List<Account> OldAcc){
        List<Territory__c> OwnersOk = new List<Territory__c>();
        for(Account AccInWork : AccToWork){
            List<Territory__c> OwnersToWork = [SELECT Name,OwnerId FROM Territory__c WHERE Name = :AccInWork.BillingPostalCode];
            if(OwnersToWork.size()>1){
                Double randomizer = math.random();
                Integer random = (randomizer*(OwnersToWork.size())).intValue();
                OwnersOk.add(OwnersToWork[random]);
            }else{
                OwnersOk.add(OwnersToWork[0]);
            }
        }
        Updater(OwnersOk, AccToWork, OldAcc);
    }


    public static void Updater(List<Territory__c> ZipToWork, List<Account> AccToWork, List<Account> OldAcc) {
        List<Account> AccOk = new List<Account>();
        List<Contact> ContactOk = new List<Contact>();
        List<Opportunity> OppOk = new List<Opportunity>();
        Integer counter = 0;
        for(Account AccInWork : AccToWork){
            //Change the Account Owner to the sales representative assigned to the new zip code
            AccInWork.OwnerId = ZipToWork[counter].OwnerId;
            AccOk.add(AccInWork);
            //Change the Owner field of all the Account’s Contacts to the same sales rep
            List<Contact> ContactToWork = [SELECT Id FROM Contact WHERE AccountId = :AccInWork.Id];
            for(Contact ContactInWork : ContactToWork){
                ContactInWork.OwnerId = ZipToWork[counter].OwnerId;
                ContactOk.add(ContactInWork);
            }
            //Change the Owner field of all the Account’s Open Opportunities to the same sales rep
            List<Opportunity> OppToWork = [SELECT Id FROM Opportunity WHERE IsClosed = False AND AccountId = :AccInWork.Id];
            for(Opportunity OppInWork : OppToWork){
                OppInWork.OwnerId = ZipToWork[counter].OwnerId;
                OppOk.add(OppInWork);
            }
            HistoryCreater(ZipToWork[counter], AccInWork, OldAcc[counter]);
            counter++;
        }
        //update AccOk;
        update ContactOk;
        update OppOk;
    }


    public static void HistoryCreater(Territory__c ZipInWork, Account AccInWork, Account OldAcc){
        Assignment_History__c oneAH = new Assignment_History__c();
        List<Territory__c> terrList = [SELECT Id FROM Territory__c WHERE Name = :OldAcc.BillingPostalCode AND OwnerId = :OldAcc.OwnerId];
        oneAH.Previous_Owner__c = OldAcc.OwnerId;
        oneAH.New_Owner__c = AccInWork.OwnerId;
        oneAH.Previous_Territory__c = terrList[0].Id;
        oneAH.New_Territory__c = ZipInWork.Id;
        oneAH.Account__c = AccInWork.Id;
        oneAH.Changed_By__c = userinfo.getUserId();
        insert oneAH;
    }
}