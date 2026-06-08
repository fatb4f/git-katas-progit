package kata

kata: {
	id:   "02.03.04"
	name: "04-stat-history"
	kind: "inspection"

	commands: ["git log --stat / --shortstat"]

	objective: "Identify change volume and touched files."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
