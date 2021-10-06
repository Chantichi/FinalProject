public without sharing class DailyCheck implements Schedulable {
    //todo
    List<Account> accs = [SELECT Id, BillingPostalCode, OwnerId FROM Account WHERE SystemModStamp >= LAST_N_DAYS:1];
    List<Territory__c> territories = [SELECT Name, OwnerId FROM Territory__c ORDER BY Name];
    Map<String, List<Id>> terrMap = new Map<String, List<Id>>();

    public void execute(SchedulableContext ctx) {
        PopulateMap();
        AccountChecker();
    }

    public void PopulateMap(){
        List<Id> owners = new List<Id>();
        for(Integer i=0; i<territories.size(); i++){
            if(i>0 && i<territories.size()-1){
                if(territories[i-1].Name != territories[i].Name){
                    List<Id> owns = new List<Id>();
                    for(Id owner : owners){
                        owns.add(owner);
                    }
                    terrMap.put(territories[i-1].Name, owns);
                    owners.clear();
                    owners.add(territories[i].OwnerId);
                }else{
                    owners.add(territories[i].OwnerId);
                }
            }else if(i==0){
                owners.add(territories[i].OwnerId);
            }else{
                if(territories[i-1].Name != territories[i].Name){
                    List<Id> owns = new List<Id>();
                    for(Id owner : owners){
                        owns.add(owner);
                    }
                    terrMap.put(territories[i-1].Name, owns);
                    owners.clear();
                    terrMap.put(territories[i].Name, new List<Id> {territories[i].OwnerId});
                }else{
                    owners.add(territories[i].OwnerId);
                    List<Id> owns = new List<Id>();
                    for(Id owner : owners){
                        owns.add(owner);
                    }
                    terrMap.put(territories[i].Name, owns);
                    owners.clear();
                }
            }
        }
    }

    public void AccountChecker(){
        List<Account> AccToUpdate = new List<Account>();
        for(Account acc : accs){
            Boolean ok = false;
            List<Id> possibleIds = new List<Id>();
            for(String zipCode : terrMap.keySet()){
                    for(Id oneId : terrMap.get(zipCode)){
                        if(acc.BillingPostalCode == zipCode){
                            if(acc.OwnerId == oneId){
                                ok = true;
                            }else{
                                possibleIds.add(oneId);
                            }
                        }
                    }
            }
            if(!ok){
                if(possibleIds.size()>1){
                    AccountUpdater(possibleIds, acc);
                    AccToUpdate.add(acc);
                }else if(possibleIds.size()==1){
                    acc.OwnerId = possibleIds[0];
                    AccToUpdate.add(acc);
                }
            }else{
                possibleIds.clear();
            }
        }
        update AccToUpdate;
    }

    public void AccountUpdater(List<Id> possibleIds, Account acc){
        Double randomizer = math.random();
        Integer random = (randomizer*(possibleIds.size())).intValue();
        acc.OwnerId = possibleIds[random];
    }
}