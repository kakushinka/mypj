trigger qualificationGetTrigger on qualificationGet__c (before insert) {
	System.debug('Hello World!');
}