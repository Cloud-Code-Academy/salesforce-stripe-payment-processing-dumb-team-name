trigger ContactTrigger on Contact (after insert) {
    if (Trigger.isAfter && Trigger.sInsert) {
    new ContactTriggerHandler().run();
  }
}