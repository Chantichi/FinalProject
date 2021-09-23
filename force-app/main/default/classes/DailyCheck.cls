public without sharing class DailyCheck implements Schedulable {
    List<Account> accs = [SELECT Id, BillingPostalCode, OwnerId FROM Account];
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
                    //System.debug(terrMap.get(territories[i-1].Name));
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
                    //System.debug(terrMap.get(territories[i-1].Name));
                    owners.clear();
                    terrMap.put(territories[i].Name, new List<Id> {territories[i].OwnerId});
                    //System.debug(terrMap.get(territories[i].Name));
                }else{
                    owners.add(territories[i].OwnerId);
                    List<Id> owns = new List<Id>();
                    for(Id owner : owners){
                        owns.add(owner);
                    }
                    terrMap.put(territories[i].Name, owns);
                    //System.debug(terrMap.get(territories[i].Name));
                    owners.clear();
                }
            }
        }
    }

    public void AccountChecker(){
        for(Account acc : accs){
            Boolean ok = false;
            //System.debug('terrMap.keySet()');
            //System.debug(terrMap.keySet());
            //System.debug('terrMap.values()');
            //System.debug(terrMap.values());
            //System.debug('terrMap.get(91000)');
            //System.debug(terrMap.get('91000'));
            for(String zipCode : terrMap.keySet()){
                List<Id> possibleIds = new List<Id>();
                if(terrMap.get(zipCode).size()>0){
                    for(Id oneId : terrMap.get(zipCode)){
                        if(acc.OwnerId == oneId){
                            ok = true;
                        }else{
                            possibleIds.add(oneId);
                        }
                    } 
                }else{
                    ok = true;
                }
                
                if(!ok){
                    if(possibleIds.size()>1){
                        AccountUpdater(possibleIds, acc);
                    }else{
                        acc.OwnerId = possibleIds[0];
                    }
                    update acc;
                }else{
                    possibleIds.clear();
                }
            }
        }
    }

    public void AccountUpdater(List<Id> possibleIds, Account acc){
        Double randomizer = math.random();
        Integer random = (randomizer*(possibleIds.size())).intValue();
        acc.OwnerId = possibleIds[random];
    }
}