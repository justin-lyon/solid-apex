/**
 */
public with sharing class DIP {

	// DIP uses an accessor of the AccountDAI Interface.
	private AccountDAI accessor;

	// Use the AccountDA implementation by default.
	public DIP() {
		this(new AccountDA());
	}

	// Constructor Injection of AccountDAI, Use this to change the AccountDAI Implementation.
	public DIP(AccountDAI access) {
		accessor = access;
	}

	// Invoke the accessor, dependent on the AccountDAI Implementation set in the constructor
	public List<Account> getRecentAccounts() {
		return accessor.queryFiveRecentAccounts();
	}

	// Invoke the accessor, dependent on the AccountDAI Implementation set in the constructor
	public void saveAccounts(List<Account> newAccounts) {
		accessor.insertAccounts(newAccounts);
	}

	/**
	 * Interface defines method signatures
	 */
	public interface AccountDAI {
		List<Account> queryFiveRecentAccounts();
		void insertAccounts(List<Account> newAccounts);
	}

	/**
	 * Concrete AccountDA implements methods by the AccountDAI Interface
	 */
	public class AccountDA implements DIP.AccountDAI {
		public List<Account> queryFiveRecentAccounts() {
			return [
				SELECT Id,
					Name,
					AccountNumber
				FROM Account
				ORDER BY CreatedDate ASC
				LIMIT 5];
		}

		public void insertAccounts(List<Account> newAccounts) {
			insert newAccounts;
		}
	}

	/**
	 * Mock also implements the methods by the AccountDAI Interface, but differently...
	 */
	public class AccountDAMock implements DIP.AccountDAI {
		public List<Account> queryFiveRecentAccounts() {
			List<Account> found = new List<Account>();
			found.add(new Account(Name = 'Test Account 1'));
			return found;
		}

		public void insertAccounts(List<Account> newAccounts) {
			Integer i = 1;
			for (Account acc : newAccounts) {
				acc.Id = '00100000000000' + i;
				i++;
			}
		}
	}
}
