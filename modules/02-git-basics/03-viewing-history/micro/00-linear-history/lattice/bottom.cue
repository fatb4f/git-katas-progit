package lattice

bottomCases: {
	"head-ref-unresolved": {
		description: "The selected ref cannot be resolved to a commit."
	}
	"empty-selected-history": {
		description: "The selected scope yields no reachable commits."
	}
	"linearity-violation": {
		description: "The selected history has a merge topology where this analysis requires a single parent chain."
	}
	"metadata-unavailable": {
		description: "A required author or subject field cannot be projected from observed commit metadata."
	}
	"evidence-divergence": {
		description: "The submitted answer surface diverges from observed repository facts."
	}
}
