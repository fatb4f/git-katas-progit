package kata

kata: {
	id:   "02.03.02"
	name: "02-limit-history"
	kind: "inspection"

	commands: ["git log -n / --since / --until"]

	objective: "Return commits inside count/date slices."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
