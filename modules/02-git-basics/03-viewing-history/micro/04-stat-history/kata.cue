package kata

kata: {
	id:    "02.03.04"
	name:  "stat-history"
	kind:  "inspection"
	level: "L1"
	source: {upstream: ["basic-staging"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log --stat", "git log --shortstat"]
	concepts: ["change volume", "file summary", "insertions", "deletions"]
	fixture: {name: "file-evolution", shape: "several commits touching multiple files"}
	task: {
		prompt:  "Identify the commit with the largest file count and a commit that includes deletions."
		outputs: [".answers/largest_commit_by_files", ".answers/commit_with_deletions"]
	}
	verify: {mode: "answer", checks: ["largest_commit_by_files", "commit_with_deletions"]}
}
