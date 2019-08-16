/**
 * Putting the I in SOLID.
 * Interface Segragation Principle
 * Simply put, children of an Interface should be a good fit.
 * Here we see that Book and Move implement Product,
 * but Movie isn't a good fit, it doesn't have an author.
 *
 * See the sample in InterfaceSegregationPrincipleTest
 */
public with sharing class ISP {

	public interface Product {
		String getName();
		String getAuthor();
	}

	public class Book implements Product {
		private String name;
		private String author;

		public Book(String n, String a) {
			this.name = n;
			this.author = a;
		}

		public String getName() {
			return name;
		}

		public String getAuthor() {
			return author;
		}
	}

	public class Movie implements Product {
		private String name;
		private String director;

		public Movie(String n, String d) {
			this.name = n;
			this.director = d;
		}

		public String getName() {
			return name;
		}

		public String getAuthor() {
			throw new CustomException('Method not supported.');
		}
	}

	public class CustomException extends Exception {}
}
