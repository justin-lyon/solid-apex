# I - Interface Segregation Principle

The Interface Segregation Princple states

> Do not force a child class to depend on a method that is not used for them.

The sample shows that Book and Movie are both Products. Products must implement a `getAuthor` method; however, Movies do not have an author, they have a director. Movies are breaking from ISP.
