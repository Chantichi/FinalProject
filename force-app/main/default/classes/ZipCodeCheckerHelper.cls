public with sharing class ZipCodeCheckerHelper {
    public static void Checker(List<Territory__c> TerritoriesToWork) {
        for(Territory__c TerritoryInWork : TerritoriesToWork){
            List<Territory__c> OldTerritories = [SELECT Name,OwnerId FROM Territory__c WHERE Name = :TerritoryInWork.Name];
            if(OldTerritories.size()>2){
                TerritoryInWork.addError('Three sales representatives already assigned to this Zip Code');
            }
        }
    }
}
