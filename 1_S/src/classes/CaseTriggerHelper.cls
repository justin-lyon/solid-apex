/**
	Example of a common TriggerHelper pattern.
	This is a bad pattern because it tightly couples the Application, Business, and Data Layers.
	Being Tightly Coupled, all three layers must be tested and deployed together.

	We can write more loosely coupled classes if we take steps to follow SRP.
 */
public with sharing class CaseTriggerHelper {

	public static void postToCustomerAccounts(List<Case> newCases) {
		// Do we have any cases with accounts?
		// Filtering and creating data structures
		List<Case> casesWithAccounts = new List<Case>();
		Set<Id> accountIds = new Set<Id>();
		for (Case newCase : newCases) {
			if (newCase.AccountId != null) {
				accountIds.add(newCase.AccountId);
				casesWithAccounts.add(newCase);
			}
		}

		// Are any of the accounts Customers?
		// Quering, Data Access
		Map<Id, Account> partnerAccounts = new Map<Id, Account> ([
			SELECT Id
			FROM Account
			WHERE Id IN :accountIds
				AND (
					Type = 'Customer - Direct'
					OR Type = 'Customer - Channel')]);

		// For the cases with accounts, create feeditems for customer accounts.
		// Filtering and Data creation
		List<FeedItem> newFeedItems = new List<FeedItem>();
		for (Case newCase : casesWithAccounts) {
			if (partnerAccounts.containsKey(newCase.AccountId)) {
				FeedItem newFeedItem = new FeedItem(
					ParentId = newCase.AccountId,
					Title = newCase.Subject,
					Body = newCase.Description);
				newFeedItems.add(newFeedItem);
			}
		}

		// post the feeditems to the customer accounts.
		// DML, Data Access
		insert newFeedItems;
	}
}
