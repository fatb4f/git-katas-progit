package schema

#GitCollector: {
	id: #KebabIdentifier
	adapter: #NonEmptyString
	argv: #NonEmptyStringList
	produces: #NonEmptyStringList
	readOnly: bool | *true
}

#CueGitAnalysisWorkflow: {
	id: #NonEmptyString
	analysis: {
		theoryRef: #NonEmptyString
		latticeRef: #NonEmptyString
	}
	input: {
		repoPath: #NonEmptyString
		ref: #NonEmptyString | *"HEAD"
	}
	collectors: [...#GitCollector] & [_, ...]
	evidence: #EvidenceShape
	report: #ReportProjection
}
