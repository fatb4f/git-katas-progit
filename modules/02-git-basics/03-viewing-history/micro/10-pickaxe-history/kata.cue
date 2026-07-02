package kata

kata: {
	id:    "02.03.10"
	name:  "pickaxe-history"
	kind:  "inspection"
	level: "L3"
	source: {upstream: ["investigation", "bisect", "Bad-commit"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log -SfeatureFlag"]
	concepts: ["pickaxe", "symbol introduction", "symbol removal", "occurrence count"]
	fixture: {name: "symbol-lifecycle", shape: "symbol introduced changed and removed"}
	task: {
		prompt:  "Find the commits where the target symbol is introduced and removed."
		outputs: [".answers/introduced_symbol_commit", ".answers/removed_symbol_commit"]
	}
	verify: {mode: "answer", checks: ["introduced_symbol_commit", "removed_symbol_commit"]}
}
