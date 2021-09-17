trigger ZipCodeUpdated on Account (before update) {
    for(Integer i=0; i<Trigger.new.size(); i++){
        if(Trigger.new[i].BillingPostalCode != Trigger.old[i].BillingPostalCode){
            ZipCodeUpdatedHelper.InitialCheck(Trigger.new, Trigger.old);
        }
    }
}