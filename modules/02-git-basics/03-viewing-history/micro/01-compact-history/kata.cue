package kata

kata: {
	id:    "02.03.01"
	name:  "compact-history"
	kind:  "inspection"
	level: "L1"
	source: {upstream: ["basic-commits"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log --oneline", "git log --oneline -3"]
	concepts: ["short hash", "subject", "output compression", "range limiting"]
	fixture: {name: "linear-5", shape: "five commits on one branch"}
	task: {
		prompt:  "Map short hashes to subjects and list the latest three subjects."
		outputs: [".answers/short_hashes", ".answers/latest_three_subjects"]
	}
	verify: {mode: "answer", checks: ["short_hashes", "latest_three_subjects"]}
}
