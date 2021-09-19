trigger ZipCodeChecker on Territory__c (before insert, after update) {
    if(Trigger.isInsert){
            ZipCodeCheckerHelper.Checker(Trigger.new);
    }else if(Trigger.isUpdate){
        for(Integer i=0; i<Trigger.new.size(); i++){
            if(Trigger.new[i].OwnerId != Trigger.old[i].OwnerId){
                ZipCodeCheckerHelper.Updater(Trigger.new, Trigger.old);
            }
        }
    }
}