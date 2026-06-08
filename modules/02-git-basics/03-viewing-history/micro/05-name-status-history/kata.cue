package kata

kata: {
	id:   "02.03.05"
	name: "05-name-status-history"
	kind: "inspection"

	commands: ["git log --name-only / --name-status"]

	objective: "Classify A/M/D file transitions."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
