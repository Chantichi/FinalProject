public without sharing class ZipCodeUpdatedHelper {
    public static void InitialCheck(List<Account> AccToWork, List<Account> OldAcc){
        Boolean ZipUpdated = false;
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
        Updater(OwnersOk, AccToWork, OldAcc, ZipUpdated);
    }


    public static void Updater(List<Territory__c> ZipToWork, List<Account> AccToWork, List<Account> OldAcc, Boolean ZipUpdated) {
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
            if(ZipUpdated){
                HistoryCreater(ZipToWork[counter], AccInWork, OldAcc[counter]);
                sendMail(AccInWork, OldAcc[counter]);
                update AccOk;
            }
            counter++;
        }
        //update AccOk;
        update ContactOk;
        update OppOk;
    }


    public static void sendMail(Account newAcc, Account oldAcc){
        List<User> user1 = [SELECT Id, email FROM User WHERE Id = :newAcc.OwnerId];
        List<User> user2 = [SELECT Id, email FROM User WHERE Id = :oldAcc.OwnerId];
        EmailTemplate tpl = [SELECT Id, subject FROM EmailTemplate WHERE Name='Owner Changed'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(tpl.Id);
        mail.setToAddresses(new List<String> {user1[0].email});
        mail.setSubject(tpl.subject);
        mail.setTargetObjectId(newAcc.OwnerId);
        //mail.setWhatId(newAcc);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
        Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
        mail2.setTemplateId(tpl.Id);
        mail2.setToAddresses(new List<String> {user2[0].email});
        mail2.setSubject(tpl.subject);
        mail2.setTargetObjectId(oldAcc.OwnerId);
        //mail2.setWhatId(newAcc);
        mail2.setSaveAsActivity(false);
        mail2.setUseSignature(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail, mail2 });
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