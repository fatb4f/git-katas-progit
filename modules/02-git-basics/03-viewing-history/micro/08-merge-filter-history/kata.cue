package kata

kata: {
	id:   "02.03.08"
	name: "08-merge-filter-history"
	kind: "inspection"

	commands: ["git log --merges / --no-merges"]

	objective: "Separate merge commits from ordinary commits."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
