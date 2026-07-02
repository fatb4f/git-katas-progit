package kata

kata: {
	id:    "02.03.09"
	name:  "message-author-date-filter"
	kind:  "inspection"
	level: "L2"
	source: {upstream: ["new bridge kata"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log --grep=\"release\"", "git log --author=\"Ada\"", "git log --since=\"2024-01-02\" --until=\"2024-01-04\""]
	concepts: ["metadata query", "author", "message", "date range"]
	fixture: {name: "metadata-varied", shape: "commits with varied authors dates and messages"}
	task: {
		prompt:  "Find commits selected by message, author, and date-range filters."
		outputs: [".answers/author_matches", ".answers/message_matches", ".answers/date_range_matches"]
	}
	verify: {mode: "answer", checks: ["author_matches", "message_matches", "date_range_matches"]}
}
