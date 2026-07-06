package lattice

import schema "example.com/git-katas-progit/schema:schema"

model: schema.#LatticeExpression & {
	id: "lattice.history.linear-provenance"
	top: "unknown repository state"

	refinements: [
		"repository exists",
		"head ref resolves",
		"reachable commit set observed",
		"parent map observed",
		"history is linear",
		"commit metadata observed",
		"boundary commits identified",
		"required witnesses extracted",
	]

	closedState: "closed linear-history provenance evidence"

	witnesses: [
		"newest-commit",
		"oldest-commit",
		"newest-author",
		"newest-subject",
		"linearity",
	]

	bottomCases: [
		"head ref unresolved",
		"selected scope has no reachable commits",
		"history shape violates linearity requirement",
		"required author metadata unavailable",
		"required subject metadata unavailable",
		"answer evidence diverges from observed facts",
	]
}
