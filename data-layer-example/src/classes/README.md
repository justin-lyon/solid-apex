# data-layer-example

# Usage

```java
public class MyBusinessLayer {
  private AccountDAI accessor;

  // Constructor Injection allows for Dependency Inversion.
  public MyBusinessLayer(AccountDAI accessor) {
    this.accessor = accessor;
  }

  public List<Account> searchRecords(searchString) {
    // SOQL/SOSL Defined on the Object Specific Data Accessor Interface (DAI)
    List<Account> foundAccounts = accessor.searchAccounts(searchString);
    return foundAccounts;
  }

  public void createRecords() {
    // DML methods merged to AccountDAI from the DmlBase.
    accessor.insertRecords(new List<Account>{ new Account(Name = 'Sample') });
  }
}
```

# Design
---
## DmlInterface.cls

Provides interface for DML Operations

```java
public interface DmlInterface {
	void insertRecords(List<SObject> newRecords);
	void updateRecords(List<SObject> records);
	void upsertRecords(List<SObject> records);
	void deleteRecords(List<SObject> records);
}
```

---
## DmlBase.cls

Implements DmlInterface

```java
public abstract class DmlBase implements DmlInterface {

	public void insertRecords(List<SObject> newRecords) {
		insert newRecords;
	}

	public void updateRecords(List<SObject> records) {
		update records;
	}

	public void upsertRecords(List<SObject> records) {
		upsert records;
	}

	public void deleteRecords(List<SObject> records) {
		delete records;
	}
}

```

---
## AccountDAI.cls

Extends DmlInterface

Provides interface for Account queries.

```java
public interface AccountDAI extends DmlInterface {
	List<Account> queryLimittedAccounts(Integer limitter);
	List<Account> searchAccounts(String searchString);
}
```

---
## AccountDA.cls

Extends DmlBase

Implements AccountDAI

```java
public inherited sharing class AccountDA extends DmlBase implements AccountDAI {
	public static final Integer MAX_RESULTS = 5;

	public List<Account> queryLimittedAccounts(Integer limitter) {
		limitter = Integer.valueOf(limitter);
		return [
			SELECT Id,
				Name
			FROM Account
			ORDER BY CreatedDate ASC
			LIMIT :limitter];
	}

	public List<Account> searchAccounts(String searchString) {
		String escapedTerm = String.escapeSingleQuotes(searchString) + '*';

		List<List<SObject>> results = [
			FIND :escapedTerm IN ALL FIELDS
			RETURNING
				Account (Id, Name)
			LIMIT :MAX_RESULTS];

		return results[0];
	}
}
```
