package kata

kata: {
	id:    "02.03.08"
	name:  "merge-filter-history"
	kind:  "inspection"
	level: "L2"
	source: {upstream: ["3-way-merge", "merge-conflict", "reverted-merge"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log --merges", "git log --no-merges", "git show --summary"]
	concepts: ["merge commit", "parent commit", "first parent", "second parent"]
	fixture: {name: "branch-merge", shape: "normal commits plus merge commit"}
	task: {
		prompt:  "Separate merge commits from ordinary commits and identify merge parents."
		outputs: [".answers/merge_commit", ".answers/merge_parents", ".answers/non_merge_count"]
	}
	verify: {mode: "answer", checks: ["merge_commit", "merge_parents", "non_merge_count"]}
}
