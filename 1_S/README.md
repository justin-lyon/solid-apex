# S - Single Responsibility Principle

The Single Responsibility Principle States that a class should do one thing and do it well. Furthermore, a Class should not modify or otherwise reach into the contents of another class.

The Sample here shows how SRP is broken. In this example are two classes, `Account` and `Person`. The Person has a method, `withdraw` that changes a member of Account.
