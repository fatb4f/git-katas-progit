package kata

kata: {
	id:   "02.03.01"
	name: "01-compact-history"
	kind: "inspection"

	commands: ["git log --oneline"]

	objective: "Map short hashes to commit subjects."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
