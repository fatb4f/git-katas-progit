package kata

kata: {
	id:    "02.03.12"
	name:  "history-query-composition"
	kind:  "inspection"
	level: "L3"
	source: {upstream: ["new capstone"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log v1.0..HEAD --graph --oneline --author=\"Ada\" --grep=\"release\" -- app/config.txt"]
	concepts: ["query composition", "shape", "range", "filter", "pathspec"]
	fixture: {name: "tagged-release", shape: "branch graph with tags authors messages and paths"}
	task: {
		prompt:  "Compose range, graph, author, message, and path filters, then explain why the result set matches."
		outputs: [".answers/composed_query_result", ".answers/explain_filter_chain"]
	}
	verify: {mode: "mixed", checks: ["composed_query_result", "explain_filter_chain"]}
}
