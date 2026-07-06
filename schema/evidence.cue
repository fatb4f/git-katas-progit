package schema

#FactID: #KebabIdentifier
#WitnessID: #KebabIdentifier
#CheckID: #KebabIdentifier

#EvidenceFact: {
	id: #FactID
	description: #NonEmptyString
	source: #NonEmptyString
}

#EvidenceWitness: {
	id: #WitnessID
	description: #NonEmptyString
	factRefs: #NonEmptyStringList
}

#EvidenceCheck: {
	id: #CheckID
	description: #NonEmptyString
	requires: #NonEmptyStringList
}

#EvidenceShape: {
	facts: {
		[string]: #EvidenceFact
	}
	witnesses: {
		[string]: #EvidenceWitness
	}
	checks: {
		[string]: #EvidenceCheck
	}
}
