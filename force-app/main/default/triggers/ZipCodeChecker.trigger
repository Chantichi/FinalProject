trigger ZipCodeChecker on Territory__c (before insert, after update) {
    if(Trigger.isInsert){
        ZipCodeCheckerHelper.Checker(Trigger.new);
    }else if(Trigger.isUpdate){
        ZipCodeCheckerHelper.Updater(Trigger.new, Trigger.old);
    }
}