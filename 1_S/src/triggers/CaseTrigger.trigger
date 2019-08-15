trigger CaseTrigger on Case (after insert) {
	if (Trigger.isAfter && Trigger.isInsert) {
		// Bad - Tightly coupled, stateless class.
		// CaseTriggerHelper.postToCustomerAccounts(Trigger.new);

		// Better - Moving towards SRP and taking advantage of a stateful OO Class.
		CaseChatterPoster poster = new CaseChatterPoster(Trigger.new);
		poster.postToCustomerAccounts();

		// Best
		// TODO
	}
}
