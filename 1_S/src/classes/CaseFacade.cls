public with sharing class CaseFacade {

	public void afterInsert(List<Case> newCases) {
		CaseChatterPoster poster = new CaseChatterPoster(newCases);
		poster.postToCustomerAccounts();
	}
}
