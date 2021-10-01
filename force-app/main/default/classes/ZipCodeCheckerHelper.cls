public without sharing class ZipCodeCheckerHelper {
    public static void Checker(List<Territory__c> TerritoriesToWork) {
        for(Territory__c TerritoryInWork : TerritoriesToWork){
            List<Territory__c> OldTerritories = [SELECT Name,OwnerId FROM Territory__c WHERE Name = :TerritoryInWork.Name];//avoid queries in for loops!!!
            if(OldTerritories.size()>2){
                TerritoryInWork.addError('Three sales representatives already assigned to this Zip Code');
            }
        }
    }


    public static void Updater(List<Territory__c> TerrToWork, List<Territory__c> OldTerr){
        List<Account> AccListToUpdate = new List<Account>();
        List<Account> AllAccounts = [SELECT Id, OwnerId, BillingPostalCode FROM Account];
        for(Integer i=0; i<TerrToWork.size(); i++){
            if(TerrToWork[i].OwnerId != OldTerr[i].OwnerId){
                for(Account OneAccount : AllAccounts){
                    if(oneAccount.BillingPostalCode == TerrToWork[i].Name && oneAccount.OwnerId == OldTerr[i].OwnerId){
                        oneAccount.OwnerId = TerrToWork[i].OwnerId;
                        AccListToUpdate.add(oneAccount);
                    }
                }
            }
        }
        update AccListToUpdate;
    }
}
