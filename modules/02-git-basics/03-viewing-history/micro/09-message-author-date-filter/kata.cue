package kata

kata: {
	id:   "02.03.09"
	name: "09-message-author-date-filter"
	kind: "inspection"

	commands: ["git log --grep / --author / --since"]

	objective: "Query commits by metadata."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
