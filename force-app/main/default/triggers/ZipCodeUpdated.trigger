trigger ZipCodeUpdated on Account (before update) {
    ZipCodeUpdatedHelper.TriggerRun(Trigger.new, Trigger.old);
}