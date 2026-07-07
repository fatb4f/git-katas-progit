package cuetool

check: {
	closedState: cueTheory.closedState
	patterns: [for _, pattern in cueTheory.patterns {pattern.id}]
	bottomCases: [for id, _ in cueTheory.bottomCases {id}]
	guards: {
		workflowUsesLocalSchema: workflow.analysis.concept != ""
		adapterContractProjectsValidation: {
			facts:     workflow.adapterContract.facts
			witnesses: workflow.adapterContract.witnesses
			checks:    workflow.adapterContract.checks
		}
	}
}
