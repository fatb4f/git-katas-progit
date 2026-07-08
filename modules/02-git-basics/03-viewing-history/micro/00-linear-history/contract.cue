package linearhistory

import lat "github.com/fatb4f/lattice/meta"

linearHistory: lat.#ObligationState & {
	id: "linear-history"

	resources: {
		"learn-git-theory": {
			path:       "theory.md#learning-target"
			role:       "learn"
			visibility: "public"
		}
		"learn-lattice-theory": {
			path:       "lattice.md#learning-target"
			role:       "learn"
			visibility: "public"
		}
		"learn-cue-lattice-theory": {
			path:       "cue-projection.md#learning-target"
			role:       "learn"
			visibility: "public"
		}
		"implement-cue-constraints": {
			path:       "cue-projection.md#git-theory-to-cue-concepts"
			role:       "implement"
			visibility: "public"
		}
		"implement-adapters": {
			path:       "deliverables.md#adapter-deliverables"
			role:       "implement"
			visibility: "public"
		}
		"implement-validation": {
			path:       "deliverables.md#cue-tool-deliverable"
			role:       "implement"
			visibility: "public"
		}
	}

	operations: {
		"understand-linear-history": {
			kind:        "learn"
			description: "Learn linear history as a selected commit path over immutable commit objects and mutable refs."
			reads: {
				"learn-git-theory": true
			}
			writes: {
				"learn-lattice-theory": true
			}
			creates: {}
			requiresGates: {
				"git-theory-preserved": true
			}
			requiresWitnesses: {
				"commit-graph-model": true
				"ref-selection-model": true
			}
		}

		"encode-as-cue-lattice": {
			kind:        "implement"
			description: "Encode selected-ref resolution, non-empty history, parent-cardinality, boundary, and metadata projection as CUE constraints."
			reads: {
				"learn-lattice-theory": true
				"learn-cue-lattice-theory": true
			}
			writes: {
				"implement-cue-constraints": true
			}
			creates: {}
			requiresGates: {
				"cue-bottom-cases-modeled": true
				"no-local-ontology": true
			}
			requiresWitnesses: {
				"linearity-constraint": true
				"boundary-witnesses": true
				"metadata-witnesses": true
			}
		}

		"implement-observation-adapters": {
			kind:        "implement"
			description: "Implement Git CLI, go-git, or gitoxide/gix observation adapters that emit data supporting the CUE lattice constraints."
			reads: {
				"implement-cue-constraints": true
			}
			writes: {
				"implement-adapters": true
			}
			creates: {}
			requiresGates: {
				"read-only-observation": true
				"adapter-does-not-own-ontology": true
			}
			requiresWitnesses: {
				"adapter-observes-refs": true
				"adapter-observes-parents": true
				"adapter-observes-metadata": true
			}
		}

		"validate-closed-understanding": {
			kind:        "validate"
			description: "Validate that learned theory, CUE constraints, and adapter observations close the linear-history understanding."
			reads: {
				"implement-cue-constraints": true
				"implement-adapters": true
			}
			writes: {
				"implement-validation": true
			}
			creates: {}
			requiresGates: {
				"closed-kernel-shape": true
				"no-widening": true
			}
			requiresWitnesses: {
				"newest-is-head": true
				"oldest-is-boundary": true
				"strict-linear-history": true
			}
		}
	}

	gates: {
		"git-theory-preserved": {
			description: "The lattice expression preserves immutable commit objects, mutable refs, selected reachability, parent relation, and metadata projection."
		}
		"cue-bottom-cases-modeled": {
			description: "Unresolved ref, empty history, nonlinear selected parent relation, missing metadata, and witness divergence are representable as bottom cases."
		}
		"no-local-ontology": {
			description: "The module does not define a parallel theory/workflow metadata schema after crossing into lattice/CUE."
		}
		"read-only-observation": {
			description: "Adapters observe refs, objects, parents, and metadata without mutating refs, index, worktree, or object database."
		}
		"adapter-does-not-own-ontology": {
			description: "Adapter payloads support the CUE lattice constraints but do not become the ontology."
		}
		"closed-kernel-shape": {
			description: "The learning and implementation surface closes as a lat.#ClosedObligationState."
		}
		"no-widening": {
			description: "Validation and deliverables do not add requirements beyond the learned theory and implementation resources admitted here."
		}
	}

	witnesses: {
		"commit-graph-model": {
			description: "A commit is learned as an immutable object with hash, tree, parent ids, author, committer, and message."
		}
		"ref-selection-model": {
			description: "HEAD or another selected ref is learned as mutable state selecting a commit graph tip."
		}
		"linearity-constraint": {
			description: "Strict selected linear history is witnessed by zero-or-one selected parent per selected commit."
		}
		"boundary-witnesses": {
			description: "Newest and oldest commits are derived from the selected commit sequence and root/boundary condition."
		}
		"metadata-witnesses": {
			description: "Newest author and subject are projected from the newest commit object."
		}
		"adapter-observes-refs": {
			description: "The implementation can resolve the selected ref to an object id."
		}
		"adapter-observes-parents": {
			description: "The implementation can read parent ids for selected commits."
		}
		"adapter-observes-metadata": {
			description: "The implementation can read author and subject metadata from commit objects."
		}
		"newest-is-head": {
			description: "The newest selected commit equals the resolved selected ref target."
		}
		"oldest-is-boundary": {
			description: "The oldest selected commit has no selected parent in scope."
		}
		"strict-linear-history": {
			description: "The selected history contains no selected merge topology when strict linearity is required."
		}
	}
}

closedLinearHistory: (lat.#MakeClosedObligationState & {
	in: linearHistory
}).out

linearHistorySelfNoWidening: lat.#NoWideningProof & {
	authority: closedLinearHistory
	target:    closedLinearHistory
}
