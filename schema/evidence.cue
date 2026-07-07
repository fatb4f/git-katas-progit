package schema

#FactID: #KebabIdentifier
#WitnessID: #KebabIdentifier
#CheckID: #KebabIdentifier
#BottomCaseID: #KebabIdentifier

#DataShapeKind: "scalar" | "list" | "map" | "record" | "boolean"
#DataFormat: "text/plain" | "application/json" | "application/x-cue" | "git/object-id" | "git/porcelain-v1"
#Severity: "error" | "warning" | "info"

#FactValueShape: {
	kind: #DataShapeKind
	format: #DataFormat
	description: #NonEmptyString
}

#FactSource: {
	collector: #KebabIdentifier
	binding: #KebabIdentifier
}

#DerivationSpec: {
	language: "cue" | "cel" | "adapter-native"
	expression: #NonEmptyString
	inputs: #NonEmptyStringList
}

#PredicateSpec: {
	language: "cue" | "cel" | "adapter-native"
	expression: #NonEmptyString
	inputs: #NonEmptyStringList
}

#CheckFailure: {
	bottomCase: #BottomCaseID
	message: #NonEmptyString
}

#BottomCaseSpec: {
	id: #BottomCaseID
	description: #NonEmptyString
	severity: #Severity | *"error"
	recoverability: "retryable" | "requires-input" | "terminal"
}

#EvidenceFact: {
	id: #FactID
	description: #NonEmptyString
	source: #FactSource
	value: #FactValueShape
	required: bool | *true
}

#EvidenceWitness: {
	id: #WitnessID
	description: #NonEmptyString
	factRefs: #NonEmptyStringList
	derivation: #DerivationSpec
	required: bool | *true
}

#EvidenceCheck: {
	id: #CheckID
	description: #NonEmptyString
	requires: #NonEmptyStringList
	predicate: #PredicateSpec
	onFailure?: #CheckFailure
	severity: #Severity | *"error"
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
	bottomCases: {
		[string]: #BottomCaseSpec
	}
}
