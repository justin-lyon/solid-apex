public with sharing class SObjectToXML implements ReportDataI {
	private List<SObject> records;
	private List<String> fields;
	private List<SObjectNode> objectNodes;
	private final Schema.SObjectType OBJECT_TYPE;

	private XmlStreamWriter writer;
	private static final String DELIMIT_LINE = '\r\n';

	public SObjectToXML(List<SObject> records, List<String> fields, Schema.SObjectType objectType) {
		this.records = records;
		this.fields = fields;
		this.OBJECT_TYPE = objectType;
		this.writer = new XmlStreamWriter();

		initNodes();
	}

	// Generate XML Document
	public String getData() {
		writer.writeStartDocument(null, '1.0');
		writer.writeProcessingInstruction('target', 'data');
		writer.writeStartElement(null, 'records', null);
		writer.writeAttribute(null, null, 'type', String.valueOf(OBJECT_TYPE));

		for (SObjectNode obj : objectNodes) {
			obj.toXml();
		}

		writer.writeEndElement();
		writer.writeEndDocument();
		String output = writer.getXmlString();
		writer.close();
		return output;
	}

	// Model the SObject Records to the inner class Node Models.
	private void initNodes() {
		List<SObjectNode> objNodes = new List<SObjectNode>();
		for (SObject record : this.records) {
			SObjectNode objNode = new SObjectNode(this.writer);
			for (String field : fields) {
				objNode.fields.add(new FieldNode(writer, field, record.get(field).toString()));
			}
		}
	}

	public class SObjectNode {
		public List<FieldNode> fields;
		private XmlStreamWriter writer;

		public SObjectNode(XmlStreamWriter w) {
			this.writer = w;
			this.fields = new List<FieldNode>();
		}

		// Generate XML for each Record
		public void toXml() {
			writer.writeStartElement(null, 'record', null);
			for(FieldNode field : fields) {
				field.toXml();
			}
			writer.writeEndElement();
		}
	}

	public class FieldNode {
		public String Name;
		public String Value;
		private XmlStreamWriter writer;

		public FieldNode(XmlStreamWriter w, String name, String value) {
			this.writer = w;
			this.Name = name;
			this.Value = value;
		}

		// Generate XML For each Field
		public void toXml() {
			writer.writeStartElement(null, 'field', null);
			writer.writeStartElement(null, 'name', null);
			writer.writeCharacters(this.Name);
			writer.writeEndElement();
			writer.writeStartElement(null, 'value', null);
			writer.writeCharacters(this.Value);
			writer.writeEndElement();
			writer.writeEndElement();
		}
	}
}
