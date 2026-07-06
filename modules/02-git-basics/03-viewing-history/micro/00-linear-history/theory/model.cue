package theory

import schema "example.com/git-katas-progit/schema:schema"

model: schema.#SCMTheory & {
	id: "scm.history.linear-provenance"

	question: "What are the newest and oldest reachable commits, and what provenance metadata belongs to the newest commit?"

	gitConcepts: [
		"HEAD",
		"reachable history",
		"commit parent chain",
		"commit metadata",
		"reverse chronological ordering",
	]

	scmContext: [
		"pre-mutation provenance read",
		"agent repository briefing",
		"history audit",
		"safe amend reset revert rebase preflight",
	]

	requiredFacts: [
		"head-ref",
		"reachable-commit-list",
		"commit-parent-map",
		"commit-author-map",
		"commit-subject-map",
	]

	downstreamUse: [
		"safe history mutation planning",
		"release boundary inspection",
		"repository state briefing",
		"evidence bundle generation",
	]
}
