package kata

kata: {
	id:    "02.03.03"
	name:  "patch-history"
	kind:  "inspection"
	level: "L1"
	source: {upstream: ["basic-commits", "amend", "basic-revert"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log -p", "git show"]
	concepts: ["patch", "diff", "added line", "removed line"]
	fixture: {name: "linear-5", shape: "commits with small text changes"}
	task: {
		prompt:  "Find the commit that added the target line and the commit that removed it."
		outputs: [".answers/commit_that_added_line", ".answers/commit_that_removed_line"]
	}
	verify: {mode: "answer", checks: ["commit_that_added_line", "commit_that_removed_line"]}
}
