# D - Dependency Inversion Principle

> AKA Dependency Injection

In my opinion this is the most important, if not merely my favorite of the SOLID design principles.

Dependency Inversion Principle states that modules should not depend on each other directly, rather they should depend via an interface (Abstration).

A Code Smell that indicates you are breaking DIP is the use of the `new` keyword. By instantiating a class with the `new` keyword, you have now tightly coupled a dependency into your class.

The example here shows how DIP can be used to invert your dependency on the Salesforce Database, essentially establishing a mockable Object-Relational Mapping (ORM) layer in your code. Apex is unique to other languages in that we can write SOQL/SOSL queries anywhere within the codebase. As useful as this is, implementing an ORM layer using a version of the DAO pattern will organize all your queries and DML statements to a single location, and will make testing your code much easier.

A more robust Data Layer Example can be found [here](../data-layer-example).
