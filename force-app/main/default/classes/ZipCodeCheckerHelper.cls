public with sharing class ZipCodeCheckerHelper {
    public static void Checker(List<Territory__c> TerritoriesToWork) {
        for(Territory__c TerritoryInWork : TerritoriesToWork){
            List<Territory__c> OldTerritories = [SELECT Name,OwnerId FROM Territory__c WHERE Name = :TerritoryInWork.Name];
            if(OldTerritories.size()>2){
                TerritoryInWork.addError('Three sales representatives already assigned to this Zip Code');
            }
        }
    }


    public static void Updater(List<Territory__c> TerrToWork, List<Territory__c> OldTerr){
        Boolean ZipUpdated = true;
        List<Account> AccList = new List<Account>();
        //List<Account> OldAccList = new List<Account>();
        for(Integer i=0; i<TerrToWork.size(); i++){
            List<Account> oneAcc = [SELECT Id, OwnerId, BillingPostalCode FROM Account WHERE BillingPostalCode = :TerrToWork[i].Name AND OwnerId = :OldTerr[i].OwnerId];
            AccList.add(oneAcc[0]);
        }
        ZipCodeUpdatedHelper.Updater(TerrToWork, AccList, AccList, ZipUpdated);
    }
}