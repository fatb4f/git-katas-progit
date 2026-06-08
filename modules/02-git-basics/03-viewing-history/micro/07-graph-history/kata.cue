package kata

kata: {
	id:   "02.03.07"
	name: "07-graph-history"
	kind: "inspection"

	commands: ["git log --graph --oneline --decorate --all"]

	objective: "Read branch tips, HEAD, and merge topology."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
