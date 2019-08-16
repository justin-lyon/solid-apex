/**
 * Putting the L in SOLID.
 * A Unit test to exemplify the Liskov Substitution Principle.
 * "A Car is a Vehicle, but a Vehicle is not a Car."
 */
@isTest
private class LiskovTest {

	static TestMethod void upcast_givenId_shouldGetString() {
		// An ID is a String of a particular format.
		Id myId = '00100000000000a';

		Test.startTest();

			// Following Liskov, we can assign a child to a parent type.
			// In this case, an ID to a String.
			String myId_AsAString = myId;

		Test.stopTest();


		System.assert(true, 'Because we\'re following Liskov, line 38 executes successfully and we hit this line.');
	}

	static TestMethod void downcast_givenString_shouldErrorOnId() {
		String myString = '123';

		Boolean isSuccess = false;
		String errorMessage = '';
		try {
			Id myString_AsAnId = myString;
		} catch(StringException exc) {
			// I cannot down-cast a String to an Id.
			isSuccess = true;
			errorMessage = exc.getTypeName() + ' ' + exc.getMessage();
		}

		System.debug(errorMessage);
		System.assert(isSuccess, 'Cannot assign Parent Type to Child.');
	}

	static TestMethod void liskovSubstitutionPrinciple() {
		// String is a String.
		String myString = '123';
		// Id is a String of a particular format.
		Id myId = '00100000000000a';

		// I can assign my Id to a String, up-cast it.
		String myIdString = myId;

		Boolean isSuccess = false;
		String errorMessage = '';
		try {
			Id myString_AsAnId = myString;
		} catch(Exception exc) {
			// In other words: An Id is a String, but a String is not an Id.
			isSuccess = true;
			errorMessage = exc.getTypeName() + ' ' + exc.getMessage();
		}

		System.debug(errorMessage);
		System.assert(isSuccess, 'Cannot assign Parent Type to Child.');
	}
}
