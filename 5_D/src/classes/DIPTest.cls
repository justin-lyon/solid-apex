@isTest
private class DIPTest {

	// Put some Accounts in the DB for testing.
	@TestSetup
	static void makeData() {
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(Name = 'Test Data 1'));
		accounts.add(new Account(Name = 'Test Data 2'));
		accounts.add(new Account(Name = 'Test Data 3'));
		accounts.add(new Account(Name = 'Test Data 4'));
		accounts.add(new Account(Name = 'Test Data 5'));
		accounts.add(new Account(Name = 'Test Data 6'));
		insert accounts;
	}

	// Test that AccountDA uses the Database records.
	static TestMethod void queryFiveRecentAccoutns_givenAccountDA_shouldGetDBRecords() {
		DIP example = new DIP();

		Test.startTest();

			List<Account> recentAccounts = example.getRecentAccounts();

		Test.stopTest();

		// Should have some accounts.
		System.assert(!recentAccounts.isEmpty());
		// We created six, method should limit to 5.
		System.assertEquals(5, recentAccounts.size());
		// The records should have IDs because they were inserted.
		System.assertNotEquals(null, recentAccounts[0].Id);
	}

	// Test that AccoutnDAMock does NOT use the Database.
	static TestMethod void queryFiveRecentAccounts_givenMock_shouldGet1Account() {
		DIP example = new DIP(new DIP.AccountDAMock());

		Test.startTest();

			List<Account> recentAccounts = example.getRecentAccounts();

		Test.stopTest();

		// Should have some accounts
		System.assert(!recentAccounts.isEmpty());
		// The mock only returns 1 account.
		System.assertEquals(1, recentAccounts.size());
		// This account was never inserted to the DB.
		System.assertEquals(null, recentAccounts[0].Id);
	}

	// Test that AccountDA uses the Database.
	static TestMethod void insertAccounts_givenAccountDA_shouldGetNewAccountId() {
		DIP example = new DIP();
		String name = 'Test for Insertion';
		Account newAccount = new Account(Name = name);

		Test.startTest();

			example.saveAccounts(new List<Account> { newAccount });

		Test.stopTest();

		// My newAccount was inserted to the DB, so it must have a new ID.
		System.assertNotEquals(null, newAccount.Id);

		// Query for newAccount by :name
		List<Account> foundAccounts = [SELECT Id, Name FROM Account WHERE Name = :name];
		// My newAccount should actually be in the DB.
		System.assert(!foundAccounts.isEmpty());
	}

	// Test that the AccountDAMock does NOT use the Database.
	static TestMethod void insertAccounts_givenMock_shouldGetFakeAccount() {
		DIP example = new DIP(new DIP.AccountDAMock());
		String name = 'Test for Insertion';
		Account newAccount = new Account(Name = name);

		Test.startTest();

			example.saveAccounts(new List<Account> { newAccount });

		Test.stopTest();

		// My Mock should pretend to insert the record, it should have an ID.
		System.assertNotEquals(null, newAccount.Id);

		// Query for My newAccount by :name.
		List<Account> foundAccounts = [SELECT Id, Name FROM Account WHERE Name = :name];
		// My newAccount should not actually be in the DB.
		System.assert(foundAccounts.isEmpty());
	}
}
