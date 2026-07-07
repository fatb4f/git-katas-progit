package cuetool

cueTheory: #CueLatticeTheory & {
	id: "cue.lattice.linear-history-workflow"

	question: "Which CUE constraints express Pro Git primitives as a monotonic lattice for linear-history validation?"

	top: "unconstrained repository bytes"

	refinements: [
		{
			id:   "object-storage-constrained"
			from: "unconstrained repository bytes"
			to:   "content-addressed Git objects"
			patternRefs: ["content-addressed-object", "closed-vocabulary"]
			why: "Pro Git's base model is a content-addressable filesystem; the first refinement is from bytes to blob, tree, commit, and tag object constraints."
		},
		{
			id:   "references-observed"
			from: "content-addressed Git objects"
			to:   "fixed reference observations"
			patternRefs: ["reference-pointer", "scalar-constraints"]
			why: "References are mutable in the repository, but inside one workflow run they become fixed observed pointers into the object lattice."
		},
		{
			id:   "three-trees-observed"
			from: "fixed reference observations"
			to:   "HEAD, index, and working tree state constrained"
			patternRefs: ["three-tree-state", "default-disjunction"]
			why: "Pro Git's three trees are not command steps here; they are comparable state snapshots constrained by object ids."
		},
		{
			id:   "commit-sequence-constrained"
			from: "HEAD, index, and working tree state constrained"
			to:   "linear commit sequence constrained"
			patternRefs: ["linear-history-set", "list-comprehension-check"]
			why: "A linear history is a commit-object list whose parent arrays monotonically refine to zero-or-one parent."
		},
		{
			id:   "validation-closes-lattice"
			from: "linear commit sequence constrained"
			to:   "closed linear-history provenance evidence"
			patternRefs: ["closed-history-payload", "projection-contract"]
			why: "Closed provenance is the successful unification of HEAD, commit objects, root boundary, and witness projections."
		},
	]

	closedState: workflow.validate.successState

	patterns: {
		"content-addressed-object": {
			id:      "content-addressed-object"
			pattern: "#GitObject refined by #Blob, #Tree, #Commit, and #AnnotatedTag"
			useWhen: "Raw adapter data claims to describe an object from Git's object database."
			why:     "Object type is a monotonic constraint: unifying type `commit` requires tree, parents, author, committer, and message."
			exampleRefs: ["schema.cue:#GitObject", "schema.cue:#Commit", "schema.cue:#Tree", "schema.cue:#AnnotatedTag"]
		}
		"closed-vocabulary": {
			id:      "closed-vocabulary"
			pattern: "string disjunctions for object types, adapters, parsers, formats, severity, and recoverability"
			useWhen: "A field has a small supported set of values."
			why:     "Closed vocabularies turn typos and unsupported adapter features into CUE conflicts early."
			exampleRefs: ["schema.cue:#GitObject.type", "schema.cue:#AdapterKind", "schema.cue:#ParserKind", "schema.cue:#DataFormat"]
		}
		"scalar-constraints": {
			id:      "scalar-constraints"
			pattern: "regular expressions and non-empty string bounds"
			useWhen: "Identifiers are used as references across workflow sections."
			why:     "Reference ids need predictable syntax before they can safely connect collectors, evidence, checks, and reports."
			exampleRefs: ["schema.cue:#SHA1", "schema.cue:#KebabIdentifier", "schema.cue:#FactID", "schema.cue:#WitnessID"]
		}
		"reference-pointer": {
			id:      "reference-pointer"
			pattern: "#Reference and #HEAD"
			useWhen: "A branch, tag, or HEAD observation must point into content-addressed storage."
			why:     "A ref is mutable over time, but a workflow observation must unify with one concrete object id."
			exampleRefs: ["schema.cue:#Reference", "schema.cue:#HEAD"]
		}
		"three-tree-state": {
			id:      "three-tree-state"
			pattern: "#ThreeTreesSnapshot and #FileState refinements"
			useWhen: "A workflow must compare HEAD, index, and working tree state."
			why:     "Clean, staged, modified, deleted, and untracked are comparative constraints over hashes, not imperative command labels."
			exampleRefs: ["schema.cue:#FileState", "schema.cue:#CleanFile", "schema.cue:#StagedFile", "schema.cue:#ThreeTreesSnapshot"]
		}
		"default-disjunction": {
			id:      "default-disjunction"
			pattern: "value | *default"
			useWhen: "A field has a stable operational default but callers may override it."
			why:     "Defaults keep ordinary workflows concise without hiding the field from the validated shape."
			exampleRefs: ["schema.cue:#CommandSpec.cwd", "schema.cue:#CommandSpec.timeoutMs", "schema.cue:#OutputBinding.stream"]
		}
		"linear-history-set": {
			id:      "linear-history-set"
			pattern: "[...#Type] & [_, ...]"
			useWhen: "A history query returns an ordered, non-empty set of commits."
			why:     "The commit sequence is a monotonic refinement over #Commit values, not a TSV line format."
			exampleRefs: ["schema.cue:#LinearHistorySet", "schema.cue:#Commit"]
		}
		"list-comprehension-check": {
			id:      "list-comprehension-check"
			pattern: "[for c in commits {true & (len(c.parents) <= 1)}]"
			useWhen: "A constraint must hold for every observed commit."
			why:     "Merge commits fall to bottom because a two-parent commit cannot unify with the linearity check."
			exampleRefs: ["schema.cue:#LinearHistorySet._linearity"]
		}
		"hidden-reusable-definition": {
			id:      "hidden-reusable-definition"
			pattern: "#linearHistoryEvidence and #linearHistoryReport"
			useWhen: "A reusable fragment should be embedded into another value and optionally exported for inspection."
			why:     "Hidden definitions prevent accidental self-reference while keeping the public `evidence` and `report` projections readable."
			exampleRefs: ["evidence.cue:#linearHistoryEvidence", "report.cue:#linearHistoryReport", "workflow.cue:workflow.evidence"]
		}
		"map-keyed-records": {
			id:      "map-keyed-records"
			pattern: "{[string]: #Type}"
			useWhen: "Entries are addressed by stable ids rather than by position."
			why:     "Facts, witnesses, checks, and bottom cases are reference targets; keying them by id makes cross-section references explicit."
			exampleRefs: ["schema.cue:#EvidenceShape", "evidence.cue:facts", "evidence.cue:witnesses"]
		}
		"closed-history-payload": {
			id:      "closed-history-payload"
			pattern: "#ClosedLinearHistory"
			useWhen: "Adapter output claims to close the linear-history provenance workflow."
			why:     "HEAD, the linear history set, root boundary, and witness projections must unify as one object."
			exampleRefs: ["schema.cue:#ClosedLinearHistory", "schema.cue:#LinearHistoryFacts", "workflow.cue:workflow.payload"]
		}
		"projection-contract": {
			id:      "projection-contract"
			pattern: "adapterContract mirrors validate.requiredFacts, requiredWitnesses, and checks"
			useWhen: "An external adapter needs a compact contract for what it must collect and validate."
			why:     "The portable workflow boundary is the adapter contract, not the kata metadata around it."
			exampleRefs: ["workflow.cue:workflow.adapterContract"]
		}
	}

	bottomCases: {
		"unresolved-ref":    "A selected ref that cannot resolve conflicts with the `head-ref` fact requirement."
		"empty-history":     "An empty reachable commit list conflicts with the non-empty history refinement."
		"nonlinear-history": "A merge topology conflicts with the linearity witness required by this workflow."
		"metadata-missing":  "Missing author or subject metadata conflicts with provenance witness extraction."
		"shape-drift":       "A required fact, witness, check, or report source path that no longer has a producer should become a schema or adapter failure."
	}

	antiPatterns: {
		"repo-schema-import":   "Do not make the portable workflow import kata, theory, or lattice schemas from this repository."
		"migration-controller": "Do not teach this CUE plane as a repository migration plan; teach it as a pattern lattice for workflow implementation."
		"prose-only-witness":   "Do not leave required evidence only in README text when it can be modeled as a fact, witness, check, or bottom case."
		"duplicated-contract":  "Do not maintain a separate adapter fact list when it can project from `validate.requiredFacts`."
	}

	workflowMapping: {
		schema: [
			"Define Git objects, refs, and three-tree snapshots before defining adapter actions.",
			"Use disjunctions and regex constraints to make unsupported object shapes fall to bottom.",
			"Expose #LinearHistoryFacts as the unification target for adapter JSON or YAML.",
		]
		collectors: [
			"Model adapter execution as producing structured Git ontology payloads.",
			"Bind the structured payload to the `linear-history` fact id.",
			"Keep raw CLI parsing outside the lattice boundary unless it emits the ontology shape.",
		]
		evidence: [
			"Keep observed facts, derived witnesses, checks, and bottom cases separate.",
			"Use keyed maps for cross-reference targets.",
			"Export evidence after defining it as a hidden reusable value.",
		]
		validate: [
			"List required facts, witnesses, and checks explicitly.",
			"Order refinements as the lattice path from top to closed state.",
			"Name bottom cases where the lattice cannot refine further.",
		]
		report: [
			"Render from workflow source paths rather than copying facts.",
			"Keep report sections as projections over validated workflow state.",
			"Use the report to explain the closed state, not to create new evidence.",
		]
	}
}
