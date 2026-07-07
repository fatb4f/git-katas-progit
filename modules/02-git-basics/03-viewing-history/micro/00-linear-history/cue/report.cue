package cuetool

import schema "example.com/git-katas-progit/schema:schema"

report: schema.#ReportProjection & {
	id: "report.history.linear-provenance"
	format: "markdown"
	audience: "agent"
	sections: [
		{
			id: "analysis-question"
			title: "Analysis question"
			description: "State the SCM question answered by the workflow."
			derivesFrom: ["workflow.analysis.theoryRef"]
			render: {kind: "object", sourcePaths: ["workflow.analysis"]}
		},
		{
			id: "git-commands"
			title: "Git commands"
			description: "List read-only Git collectors and produced fact ids."
			derivesFrom: ["workflow.collectors"]
			render: {kind: "table", sourcePaths: ["workflow.collectors[*].id", "workflow.collectors[*].command", "workflow.collectors[*].outputs"]}
		},
		{
			id: "observed-facts"
			title: "Observed facts"
			description: "Project collector outputs into typed fact slots."
			derivesFrom: ["workflow.evidence.facts", "workflow.validate.requiredFacts"]
			render: {kind: "table", sourcePaths: ["workflow.evidence.facts", "workflow.validate.requiredFacts"]}
		},
		{
			id: "witnesses"
			title: "Witnesses"
			description: "Project derived witnesses from observed facts."
			derivesFrom: ["workflow.evidence.witnesses", "workflow.validate.requiredWitnesses"]
			render: {kind: "table", sourcePaths: ["workflow.evidence.witnesses", "workflow.validate.requiredWitnesses"]}
		},
		{
			id: "checks"
			title: "Checks"
			description: "Project machine-checkable analysis checks and bottom cases."
			derivesFrom: ["workflow.evidence.checks", "workflow.validate.checks", "workflow.validate.bottomCases"]
			render: {kind: "table", sourcePaths: ["workflow.evidence.checks", "workflow.evidence.bottomCases", "workflow.validate.checks"]}
		},
		{
			id: "scm-management-use"
			title: "SCM management use"
			description: "Project the closed analysis state for downstream repository operations."
			derivesFrom: ["workflow.analysis.latticeRef", "workflow.validate.refinements"]
			render: {kind: "list", sourcePaths: ["workflow.validate.refinements", "workflow.validate.successState"]}
		},
	]
}
