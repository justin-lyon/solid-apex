# data-layer-example

---
## DmlInterface.cls

Provides interface for DML Operations

```java
void insertRecords(List<SObject> newRecords);
void updateRecords(List<SObject> records);
void upsertRecords(List<SObject> records);
void deleteRecords(List<SObject> records);
```

---
## DmlBase.cls

Implements DmlInterface

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
