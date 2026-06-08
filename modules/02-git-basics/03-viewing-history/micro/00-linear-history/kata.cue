package kata

kata: {
	id:   "02.03.00"
	name: "00-linear-history"
	kind: "inspection"

	commands: ["git log"]

	objective: "Identify newest/oldest commit and metadata."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
