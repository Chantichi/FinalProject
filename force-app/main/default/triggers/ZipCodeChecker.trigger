trigger ZipCodeChecker on Territory__c (before insert) {
    ZipCodeCheckerHelper.Checker(Trigger.new);
}