public without sharing class ZipCodeUpdatedHelper {
    public static void TriggerRun(List<Account> AccToWork, List<Account> OldAcc){
        for(Integer i=0; i<AccToWork.size(); i++){
            if(AccToWork[i].BillingPostalCode != OldAcc[i].BillingPostalCode || AccToWork[i].OwnerId != OldAcc[i].OwnerId){
                InitialCheck(AccToWork, OldAcc);
            }
        }
    }

    public static void InitialCheck(List<Account> AccToWork, List<Account> OldAcc){
        Boolean ZipUpdated = false;
        List<Territory__c> OwnersOk = new List<Territory__c>();
        List<Territory__c> AllOwners = [SELECT Name, OwnerId FROM Territory__c];
        List<Territory__c> OwnersToWork = new List<Territory__c>();
        for(Integer i=0; i<AccToWork.size(); i++){
            for(Territory__c OneOwner : AllOwners){
                if(OneOwner.Name == AccToWork[i].BillingPostalCode){
                    OwnersToWork.add(OneOwner);
                }
            }
            if(OwnersToWork.size()>1){
                Double randomizer = math.random();
                Integer random = (randomizer*(OwnersToWork.size())).intValue();
                OwnersOk.add(OwnersToWork[random]);
                Territory__c OwnerInWork = OwnersToWork[random];
                AccountUpdater(OwnerInWork, AccToWork[i], OldAcc[i]);
                ContactUpdater(OwnerInWork, AccToWork[i]);
                OpportunityUpdater(OwnerInWork, AccToWork[i]);
                HistoryCreater(OwnerInWork, AccToWork[i], OldAcc[i]);
            }else{
                OwnersOk.add(OwnersToWork[0]);
                AccountUpdater(OwnersToWork[0], AccToWork[i], OldAcc[i]);
                ContactUpdater(OwnersToWork[0], AccToWork[i]);
                OpportunityUpdater(OwnersToWork[0], AccToWork[i]);
                HistoryCreater(OwnersToWork[0], AccToWork[i], OldAcc[i]);
            }
        }
    }


    public static void AccountUpdater(Territory__c ZipToWork, Account AccToWork, Account OldAcc){
        AccToWork.OwnerId = ZipToWork.OwnerId;
        sendMail(AccToWork, OldAcc);
    }


    public static void ContactUpdater(Territory__c ZipToWork, Account AccToWork){
        List<Contact> ContactOk = new List<Contact>();
        List<Contact> AllContactsToWork = [SELECT Id, AccountId FROM Contact];
        List<Contact> ContactToWork = new List<Contact>();
        for(Contact OneContact : AllContactsToWork){
            if(OneContact.accountId == AccToWork.Id){
                ContactToWork.add(OneContact);
            }
        }
        for(Contact ContactInWork : ContactToWork){
            ContactInWork.OwnerId = ZipToWork.OwnerId;
            ContactOk.add(ContactInWork);
        }
        update ContactOk;
    }


    public static void OpportunityUpdater(Territory__c ZipToWork, Account AccToWork){
        List<Opportunity> OppOk = new List<Opportunity>();
        List<Opportunity> AllOppsToWork = [SELECT Id, AccountId FROM Opportunity WHERE IsClosed = False];
        List<Opportunity> OppToWork = new List<Opportunity>();
        for(Opportunity OneOpp : AllOppsToWork){
            if(OneOpp.AccountId == AccToWork.Id){
                OppToWork.add(OneOpp);
            }
        }
        for(Opportunity OppInWork : OppToWork){
            OppInWork.OwnerId = ZipToWork.OwnerId;
            OppOk.add(OppInWork);
        }
        update OppOk;
    }


    public static void sendMail(Account newAcc, Account oldAcc){
        List<User> user1 = [SELECT Id, email FROM User WHERE Id = :newAcc.OwnerId];
        List<User> user2 = [SELECT Id, email FROM User WHERE Id = :oldAcc.OwnerId];
        EmailTemplate tpl = [SELECT Id, subject FROM EmailTemplate WHERE Name='Owner Changed'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(tpl.Id);
        mail.setToAddresses(new List<String> {user1[0].email});
        mail.setTargetObjectId(newAcc.OwnerId);
        mail.setWhatId(newAcc.Id);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
        Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
        mail2.setTemplateId(tpl.Id);
        mail2.setToAddresses(new List<String> {user2[0].email});
        mail2.setTargetObjectId(newAcc.OwnerId);
        mail2.setWhatId(newAcc.Id);
        mail2.setSaveAsActivity(false);
        mail2.setUseSignature(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail, mail2 });
    }


    public static void HistoryCreater(Territory__c ZipInWork, Account AccInWork, Account OldAcc){
        Assignment_History__c oneAH = new Assignment_History__c();
        List<Territory__c> terrList = [SELECT Id FROM Territory__c WHERE Name = :OldAcc.BillingPostalCode AND OwnerId = :OldAcc.OwnerId];
        if(terrList.size()>0){
            oneAH.Previous_Owner__c = OldAcc.OwnerId;
            oneAH.New_Owner__c = AccInWork.OwnerId;
            oneAH.Previous_Territory__c = terrList[0].Id;
            oneAH.New_Territory__c = ZipInWork.Id;
            oneAH.Account__c = AccInWork.Id;
            oneAH.Changed_By__c = userinfo.getUserId();
            insert oneAH;
        }
    }
}