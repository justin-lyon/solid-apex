@isTest
private class CaseTriggerHelperTest {
	/**
		We have to make data in Salesforce so we can test our tightly coupled code.
	 */
	@TestSetup
	static void makeData() {
		Account prospectAccount = new Account(
			Name = 'Test Prospect',
			Type = 'Prospect');
		Account custDirectAccount = new Account(
			Name = 'Test Cust Direct',
			Type = 'Customer - Direct');
		Account custChannelAccount = new Account(
			Name = 'Test Cust Channel',
			Type = 'Customer - Channel');

		List<Account> accounts = new List<Account>();
		accounts.add(prospectAccount);
		accounts.add(custDirectAccount);
		accounts.add(custChannelAccount);

		// Touch the DB so we can create accounts
		insert accounts;
	}
	static TestMethod void postToCustomerAccounts_givenNewCases_shouldGetNewFeedItemsOnCustomerAccounts() {
		List<Case> newCases = new List<Case>();
		// Touch the Data Base so we can create cases.
		for (Account acc : [
			SELECT Id
			FROM Account]) {

			newCases.add(new Case(
				AccountId = acc.Id,
				Subject = 'Test Subject',
				Description = 'This is a description.'));
		}

		Test.startTest();

			/**
				Note this is an Integration Test.
				Testing from the Trigger all the way down to the database.
				There is no method invocation, no unit under test.
			 */
			insert newCases;

		Test.stopTest();

		/**
			We have to touch the data base here again to write our assertion.
		 */
		List<FeedItem> newFeedItems = [
			SELECT Id,
				ParentId
			FROM FeedItem];

		/**
			All we wanted to test was that we got our feeditems on the accounts,
			but we just tested all code that executed from the Case Trigger, both Before AND After.
		 */
		System.assertEquals(2, newFeedItems.size());
	}
}
