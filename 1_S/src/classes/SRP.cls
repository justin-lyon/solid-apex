/**
 * Putting the S in SOLID.
 * Single Responsibility Principle (SRP)
 * The Person Class has a method that prints and modifies the balance of an Account.
 * This violates SRP because one class should not reach into or modify the contents of another.
 * These classes are tightly coupled. Because they are tightly coupled,
 * Any changes in one class have a high risk of impacting the other.
 */
public with sharing class SRP {
	public class Account {
		private Decimal balance = 0;

		public void setBalance(Decimal x) {
			this.balance = x;
		}

		public Decimal getBalance() {
			return this.balance;
		}
	}

	public class Person {
		SRP.Account account;

		public Person() {
			this.account = new SRP.Account();
		}

		public void withdraw(Decimal x) {
			Decimal balance = account.getBalance();
			Decimal newBalance = balance - x;
			account.setBalance(newBalance);
			System.debug('Your new balance is: ' + newBalance);
		}
	}
}
