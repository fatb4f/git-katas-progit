package cuetool

import schema "example.com/git-katas-progit/schema:schema"

report: schema.#ReportProjection & {
	id: "report.history.linear-provenance"
	format: "markdown"
	sections: [
		{id: "analysis-question", title: "Analysis question", description: "State the SCM question answered by the workflow."},
		{id: "collectors", title: "Collectors", description: "List Git fact collectors and produced facts."},
		{id: "evidence", title: "Evidence", description: "Summarize observed facts and required witnesses."},
		{id: "checks", title: "Checks", description: "Summarize required checks and failures."},
		{id: "scm-use", title: "SCM use", description: "Explain downstream repository-management use."},
	]
}
