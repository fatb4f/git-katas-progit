package kata

kata: {
	id:    "02.03.02"
	name:  "limit-history"
	kind:  "inspection"
	level: "L1"
	source: {upstream: ["new bridge kata"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log -2", "git log --since=\"2024-01-03\"", "git log --until=\"2024-01-03\""]
	concepts: ["history slice", "date filter", "count limit"]
	fixture: {name: "linear-5", shape: "five commits with controlled dates"}
	task: {
		prompt:  "List commits selected by count, since-date, and until-date filters."
		outputs: [".answers/latest_two_commits", ".answers/commits_after_date", ".answers/commits_before_date"]
	}
	verify: {mode: "answer", checks: ["latest_two_commits", "commits_after_date", "commits_before_date"]}
}
