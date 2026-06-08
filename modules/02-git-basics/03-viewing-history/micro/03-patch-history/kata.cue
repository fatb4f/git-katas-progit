package kata

kata: {
	id:   "02.03.03"
	name: "03-patch-history"
	kind: "inspection"

	commands: ["git log -p / git show"]

	objective: "Find which commit added or removed a line."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
