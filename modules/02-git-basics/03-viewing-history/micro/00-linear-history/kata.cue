package kata

kata: {
	id:    "02.03.00"
	name:  "linear-history"
	kind:  "inspection"
	level: "L1"
	source: {upstream: ["basic-commits"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log"]
	concepts: ["commit", "hash", "author", "date", "message", "reverse chronological order"]
	fixture: {name: "linear-5", shape: "five commits on one branch"}
	task: {
		prompt:  "Identify the newest commit, oldest commit, author field, and latest commit subject."
		outputs: [".answers/newest_commit", ".answers/oldest_commit", ".answers/author_field", ".answers/commit_subject"]
	}
	verify: {mode: "answer", checks: ["newest_commit", "oldest_commit", "author_field", "commit_subject"]}
}
