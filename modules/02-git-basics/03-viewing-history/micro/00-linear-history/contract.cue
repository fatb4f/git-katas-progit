package linearhistory

import lat "github.com/fatb4f/lattice/meta"

linearHistory: lat.#ObligationState & {
	id: "linear-history"

	resources: {
		"git-theory": {
			path:       "theory.md#learning-target"
			role:       "authority"
			visibility: "public"
		}
		"lattice-theory": {
			path:       "lattice.md#learning-target"
			role:       "authority"
			visibility: "public"
		}
		"cue-kernel-theory": {
			path:       "cue-projection.md#learning-target"
			role:       "authority"
			visibility: "public"
		}
		"git-cli-observer": {
			path:       "deliverables.md#git-cli-adapter-deliverable"
			role:       "input"
			visibility: "public"
		}
		"cue-constraints": {
			path:       "cue-projection.md#git-theory-to-cue-constraints"
			role:       "authority"
			visibility: "public"
		}
		"kernel-evidence-tooling": {
			path:       "deliverables.md#kernel-evidence-deliverable"
			role:       "authority"
			visibility: "public"
		}
		"cue-cmd-runner": {
			path:       "deliverables.md#cue-cmd-runner-deliverable"
			role:       "generated-output"
			visibility: "public"
		}
	}

	operations: {
		"learn-linear-history-theory": {
			kind:        "inspect"
			description: "Learn selected linear history as immutable commit objects, mutable refs, reachability, parent relation, and metadata projection."
			reads: {
				"git-theory": true
			}
			writes: {}
			creates: {}
			requiresGates: {
				"git-theory-preserved": true
			}
			requiresWitnesses: {
				"commit-graph-model": true
				"ref-selection-model": true
			}
		}

		"encode-cue-lattice-constraints": {
			kind:        "validate"
			description: "Encode the lattice model as CUE constraints whose failed unifications represent bottom cases."
			reads: {
				"git-theory": true
				"lattice-theory": true
				"cue-kernel-theory": true
			}
			writes: {
				"cue-constraints": true
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

		"collect-git-cli-evidence": {
			kind:        "collect-evidence"
			description: "Run a read-only Git CLI observer and emit observations that can become kernel evidence."
			reads: {
				"git-cli-observer": true
				"cue-constraints": true
			}
			writes: {
				"kernel-evidence-tooling": true
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

		"close-evidence-tooling": {
			kind:        "validate"
			description: "Close the trusted CUE tooling surface by requiring evidence, checks, and no-widening before report or generated output admission."
			reads: {
				"cue-constraints": true
				"kernel-evidence-tooling": true
			}
			writes: {}
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

		"generate-optional-cue-cmd-runner": {
			kind:        "generate"
			description: "Optionally generate a cue cmd workflow runner that invokes the observer and feeds CUE validation without owning the semantic core."
			reads: {
				"git-cli-observer": true
				"cue-constraints": true
				"kernel-evidence-tooling": true
			}
			writes: {}
			creates: {
				"cue-cmd-runner": true
			}
			requiresGates: {
				"cue-cmd-is-runner-only": true
			}
			requiresWitnesses: {
				"runner-feeds-validation": true
			}
		}
	}

	gates: {
		"git-theory-preserved": {
			description: "The lattice and CUE constraints preserve immutable commit objects, mutable refs, selected reachability, parent relation, and metadata projection."
		}
		"cue-bottom-cases-modeled": {
			description: "Unresolved ref, empty history, nonlinear selected parent relation, missing metadata, and witness divergence are represented as CUE bottom cases."
		}
		"no-local-ontology": {
			description: "The module does not define a separate workflow metadata ontology after crossing into CUE lattice theory."
		}
		"read-only-observation": {
			description: "The Git CLI observer collects refs, objects, parents, and metadata without mutating refs, index, worktree, or object database."
		}
		"adapter-does-not-own-ontology": {
			description: "Adapter payloads are evidence inputs for CUE constraints and kernel tooling; they do not become the ontology."
		}
		"closed-kernel-shape": {
			description: "The trustworthy tooling surface closes through the lattice meta kernel."
		}
		"no-widening": {
			description: "Generated outputs and reports cannot introduce undeclared resources, operations, gates, or witnesses."
		}
		"cue-cmd-is-runner-only": {
			description: "cue cmd may orchestrate adapter execution and validation, but it does not own Git theory, adapter semantics, or evidence declarations."
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
			description: "The observer resolves the selected ref to an object id."
		}
		"adapter-observes-parents": {
			description: "The observer reads parent ids for selected commits."
		}
		"adapter-observes-metadata": {
			description: "The observer reads author and subject metadata from commit objects."
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
		"runner-feeds-validation": {
			description: "The optional runner feeds observer output into CUE validation and does not bypass kernel evidence checks."
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
