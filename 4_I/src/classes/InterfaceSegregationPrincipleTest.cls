@isTest
private class InterfaceSegregationPrincipleTest {
	// Book follows the contract of the interface is implements, good.
	static TestMethod void getAuthor_givenBook_shouldGetJimButcher() {
		String dresdenAuthor = 'Jim Butcher';
		ISP.Product dresden = new ISP.Book('Dresden Files', dresdenAuthor);

		Test.startTest();

			String authorName = dresden.getAuthor();

		Test.stopTest();

		System.assertEquals(dresdenAuthor, authorName);
	}

	// Movie does not follow the contract of its Product Interface, bad.
	// This breaks the ISP.
	static TestMethod void getAuthor_givenMovie_shouldGetException() {
		ISP.Product avengers = new ISP.Movie('Avengers: Endgame', 'Anthony Russo');

		Boolean isSuccess = false;
		Test.startTest();

			try {
				avengers.getAuthor();
			} catch(ISP.CustomException cexc) {
				isSuccess = true;
			}

		Test.stopTest();

		System.assert(isSuccess, 'Should throw exception because it breaks from ISP.');
	}
}
