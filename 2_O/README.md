# O - Open/Closed Principle

Entities of software, such as classes and methods, should be open for extension but closed for modification. This means that classes and methods should be allowed to be extended, but not edited.

The sample code here is a good example of Open/Closed Principle. The Business needs to convert their Salesforce Data to CSV and XML, and want the option to support additional formats in the future like JSON. The `ReportDataI` Interface defines the method signature, but the implementation is defined by individual classes of SObjectToCSV and SObjectToXML. These classes are "Dev Complete" or "Closed". However the Interface is open to extension because in the future we can create a new class SObjectToJSON.
