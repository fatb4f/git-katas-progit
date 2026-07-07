package schema

#AdapterKind: "git" | "cue" | "filesystem" | "process"
#StreamName: "stdout" | "stderr" | "exit-code"
#ParserKind: "exact-text" | "line-regexp" | "tsv" | "json" | "cue" | "adapter-native"

#CommandSpec: {
	executable: #NonEmptyString
	args: [...#NonEmptyString]
	cwd: #NonEmptyString | *"{repoPath}"
	timeoutMs: int & >0 | *30000
}

#ParserSpec: {
	id: #KebabIdentifier
	kind: #ParserKind
	description: #NonEmptyString
	pattern?: #NonEmptyString
	fields?: #NonEmptyStringList
}

#ParameterSpec: {
	type: "string" | "int" | "bool"
	required: bool | *true
	default?: #NonEmptyString
	description: #NonEmptyString
}

#OutputBinding: {
	id: #KebabIdentifier
	stream: #StreamName | *"stdout"
	parser: #KebabIdentifier
	fact: #FactID
}

#GitCollector: {
	id: #KebabIdentifier
	adapter: #AdapterKind & "git"
	command: #CommandSpec
	parsers: [...#ParserSpec] & [_, ...]
	outputs: [...#OutputBinding] & [_, ...]
	produces: [for output in outputs {output.fact}]
	readOnly: bool | *true
}

#AnalysisRefinement: {
	id: #KebabIdentifier
	description: #NonEmptyString
	requiresFacts?: #NonEmptyStringList
	requiresWitnesses?: #NonEmptyStringList
	bottomCases?: #NonEmptyStringList
	promotesTo: #NonEmptyString
}

#AnalysisValidation: {
	requiredFacts: #NonEmptyStringList
	requiredWitnesses: #NonEmptyStringList
	checks: #NonEmptyStringList
	refinements: [...#AnalysisRefinement] & [_, ...]
	bottomCases: #NonEmptyStringList
	successState: #NonEmptyString
}

#CueGitAnalysisWorkflow: {
	id: #NonEmptyString
	version: #NonEmptyString | *"v1"
	analysis: {
		theoryRef: #NonEmptyString
		latticeRef: #NonEmptyString
	}
	parameters: {
		[string]: #ParameterSpec
	}
	input: {
		repoPath: #NonEmptyString
		ref: #NonEmptyString | *"HEAD"
	}
	collectors: [...#GitCollector] & [_, ...]
	evidence: #EvidenceShape
	validate: #AnalysisValidation
	report: #ReportProjection
	adapterContract: {
		parameters: #NonEmptyStringList
		facts: #NonEmptyStringList
		witnesses: #NonEmptyStringList
		checks: #NonEmptyStringList
	}
}
