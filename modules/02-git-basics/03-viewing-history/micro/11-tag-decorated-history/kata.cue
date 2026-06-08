package kata

kata: {
	id:   "02.03.11"
	name: "11-tag-decorated-history"
	kind: "inspection"

	commands: ["git log --decorate / tag..HEAD"]

	objective: "Read tags as commit refs and release boundaries."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
