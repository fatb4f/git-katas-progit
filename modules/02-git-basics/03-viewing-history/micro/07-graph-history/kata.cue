package kata

kata: {
	id:    "02.03.07"
	name:  "graph-history"
	kind:  "inspection"
	level: "L2"
	source: {upstream: ["basic-branching", "ff-merge", "3-way-merge"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log --graph --oneline --decorate --all"]
	concepts: ["DAG", "branch tip", "HEAD", "decoration", "reachability"]
	fixture: {name: "branch-merge", shape: "two branches and one merge commit"}
	task: {
		prompt:  "Read the graph output to identify HEAD, branch tips, and the merge commit."
		outputs: [".answers/head_branch", ".answers/branch_tips", ".answers/merge_commit"]
	}
	verify: {mode: "answer", checks: ["head_branch", "branch_tips", "merge_commit"]}
}
