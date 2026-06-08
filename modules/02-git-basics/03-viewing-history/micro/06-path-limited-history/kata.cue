package kata

kata: {
	id:   "02.03.06"
	name: "06-path-limited-history"
	kind: "inspection"

	commands: ["git log -- path/to/file"]

	objective: "Trace one file and exclude unrelated commits."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
