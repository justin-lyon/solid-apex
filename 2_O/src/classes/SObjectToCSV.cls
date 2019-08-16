public with sharing class SObjectToCSV implements ReportDataI {
	private List<SObject> records;
	private List<String> fields;

	private static final String DELIMIT_ROW = ',';
	private static final String DELIMIT_LINE = '\r\n';

	public SObjectToCSV(List<SObject> records, List<String> fields) {
		this.records = records;
		this.fields = fields;
	}

	public String getData() {
		List<String> csvRows = new List<String>();

		String headerRow = String.join(fields, DELIMIT_ROW);
		csvRows.add(headerRow);

		for (SObject obj : this.records) {
			List<String> rowColumns = new List<String>();
			for (String field : fields) {
				rowColumns.add(obj.get(field).toString());
			}
			csvRows.add(String.join(rowColumns, DELIMIT_ROW));
		}

		return String.join(csvRows, DELIMIT_LINE);
	}
}
