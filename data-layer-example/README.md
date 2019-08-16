# data-layer-example

This pattern allows for Dependency Inversion on the Data Layer with Salesforce Apex. This is consistent with SOLID design principles and N-Tier Architecture. By following this pattern, we can achieve more maintainable, testable code bases in Salesforce.

Like Triggers, each SObject that we work with requires a Data Access Module. That Apex Module begins with the <Object Name> Data Accessor Interface or DAI. The Example here uses Account, see AccountDAI.

All DML Operations are supported from your DAI as it extends the DmlInterface. The only code you need to write are the queries specific to your sObject. You Data Accessor (DA, See AccountDA) implements the queries defined in the DAI, and extends the DmlBase to fulfill its contract with the DmlInterface.

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

Provides interface for DML Operations. All DML Operations are generic and available to most SObjects. This Interface will be implemented by a Base Class that our classes extend.

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

Implement the SObject Generic DML Methods. These are extended onto our sObject specific Data Accessors.

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

By extending the DmlInterface, any Implementation must include the methods from DmlInterface.
The AccountDAI Interface adds Account specific queries to the interface contract.

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

By implementing AccountDAI the AccountDA is under contract to implement all methods defined in both the DmlInterface and the AccountDAI. By extending DmlBase, the AccountDA has defined the implementation for the DmlInterface - therefore only needs to define the implementation for the queries in AccountDAI.

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
