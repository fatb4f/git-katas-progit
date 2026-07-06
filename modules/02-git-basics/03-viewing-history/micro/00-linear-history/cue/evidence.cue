package cuetool

import schema "example.com/git-katas-progit/schema:schema"

evidence: schema.#EvidenceShape & {
	facts: {
		"head-ref": {id: "head-ref", description: "Resolved selected ref.", source: "resolve-head"}
		"reachable-history": {id: "reachable-history", description: "Observed selected history.", source: "collect-history-metadata"}
		"parent-map": {id: "parent-map", description: "Observed parent relations.", source: "collect-history-metadata"}
		"author-map": {id: "author-map", description: "Observed author metadata.", source: "collect-history-metadata"}
		"subject-map": {id: "subject-map", description: "Observed subject metadata.", source: "collect-history-metadata"}
	}

	witnesses: {
		"newest-commit": {id: "newest-commit", description: "Newest selected object.", factRefs: ["head-ref", "reachable-history"]}
		"oldest-commit": {id: "oldest-commit", description: "Oldest selected object.", factRefs: ["reachable-history", "parent-map"]}
		"newest-author": {id: "newest-author", description: "Newest author metadata.", factRefs: ["head-ref", "author-map"]}
		"newest-subject": {id: "newest-subject", description: "Newest subject metadata.", factRefs: ["head-ref", "subject-map"]}
		"linearity": {id: "linearity", description: "Single-parent selected shape.", factRefs: ["parent-map"]}
	}

	checks: {
		"head-resolves": {id: "head-resolves", description: "Selected ref resolves.", requires: ["head-ref"]}
		"history-non-empty": {id: "history-non-empty", description: "Selected history contains records.", requires: ["reachable-history"]}
		"newest-is-head": {id: "newest-is-head", description: "Newest record matches selected ref.", requires: ["head-ref", "reachable-history"]}
		"metadata-present": {id: "metadata-present", description: "Required metadata is present.", requires: ["author-map", "subject-map"]}
	}
}
