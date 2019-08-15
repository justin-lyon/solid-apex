public with sharing class CaseChatterPoster {
	private static final String ACCOUNT_TYPE_CUST_DIRECT = 'Customer - Direct';
	private static final String ACCOUNT_TYPE_CUST_CHANNEL = 'Customer - Channel';
	private static final Set<String> ACCOUNT_TYPES;

	private List<Case> cases;

	static {
		ACCOUNT_TYPES = new Set<String> {
			ACCOUNT_TYPE_CUST_DIRECT,
			ACCOUNT_TYPE_CUST_CHANNEL
		};
	}

	public CaseChatterPoster(List<Case> cases) {
		this.cases = cases;
	}

	public void postToCustomerAccounts() {
		List<Case> casesWithAccounts = new List<Case>();
		Set<Id> accountIds = new Set<Id>();
		for (Case newCase : cases) {
			if (hasAccountParent(newCase)) {
				casesWithAccounts.add(newCase);
				accountIds.add(newCase.AccountId);
			}
		}

		Map<Id, Account> partnerAccounts = new Map<Id, Account>(
			queryCustomerAccountsById(accountIds));

		List<FeedItem> feedItems = new List<FeedItem>();

		for (Case newCase : casesWithAccounts) {
			if (partnerAccounts.containsKey(newCase.AccountId)) {
				feedItems.add(buildFeedItem(newCase));
			}
		}

		insert feedItems;
	}

	private List<Account> queryCustomerAccountsById(Set<Id> accountIds) {
		return [
			SELECT Id
			FROM Account
			WHERE Id IN :accountIds
			AND Type IN :ACCOUNT_TYPES];
	}

	private FeedItem buildFeedItem(Case newCase) {
		return new FeedItem(
			ParentId = newCase.AccountId,
			Title = newCase.Subject,
			Body = newCase.Description);
	}

	private Boolean hasAccountParent(Case newCase) {
		return newCase.AccountId != null;
	}
}
