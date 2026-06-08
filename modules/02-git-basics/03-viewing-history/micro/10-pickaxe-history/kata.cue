package kata

kata: {
	id:   "02.03.10"
	name: "10-pickaxe-history"
	kind: "inspection"

	commands: ["git log -S<string>"]

	objective: "Locate introduction/removal of a symbol."

	verify: {
		mode: "answer"
		principle: "Check extracted invariant, not exact command spelling."
	}
}
