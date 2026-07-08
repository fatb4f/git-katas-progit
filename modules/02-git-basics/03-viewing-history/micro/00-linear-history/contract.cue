package linearhistory

import lat "github.com/fatb4f/lattice/meta"

linearHistory: lat.#ObligationState & {
	id: "linear-history"

	resources: {
		"theory": {
			path:       "modules/02-git-basics/03-viewing-history/micro/00-linear-history/theory.md"
			role:       "authority"
			visibility: "public"
		}
		"lattice": {
			path:       "modules/02-git-basics/03-viewing-history/micro/00-linear-history/lattice.md"
			role:       "projection"
			visibility: "public"
		}
		"cue-projection": {
			path:       "modules/02-git-basics/03-viewing-history/micro/00-linear-history/cue-projection.md"
			role:       "projection"
			visibility: "public"
		}
		"deliverables": {
			path:       "modules/02-git-basics/03-viewing-history/micro/00-linear-history/deliverables.md"
			role:       "projection"
			visibility: "public"
		}
		"contract": {
			path:       "modules/02-git-basics/03-viewing-history/micro/00-linear-history/contract.cue"
			role:       "authority"
			visibility: "public"
		}
	}

	operations: {
		"cross-theory-to-lattice": {
			kind:        "project"
			description: "Project linear-history Git theory into lattice/kernel concepts."
			reads: {
				"theory": true
			}
			writes: {
				"lattice": true
			}
			creates: {}
			requiresGates: {
				"kernel-vocabulary-only": true
				"semantic-preservation": true
			}
			requiresWitnesses: {
				"linear-history-invariants": true
			}
		}

		"project-lattice-to-cue": {
			kind:        "project"
			description: "Express the lattice projection as a CUE obligation state over the meta kernel."
			reads: {
				"lattice": true
			}
			writes: {
				"cue-projection": true
				"contract": true
			}
			creates: {}
			requiresGates: {
				"closed-kernel-shape": true
				"no-local-ontology": true
			}
			requiresWitnesses: {
				"kernel-import": true
			}
		}

		"emit-deliverables": {
			kind:        "derive"
			description: "Derive workflow, adapter, and CUE tool deliverables from the kernel-shaped contract."
			reads: {
				"contract": true
				"cue-projection": true
			}
			writes: {
				"deliverables": true
			}
			creates: {}
			requiresGates: {
				"no-deliverable-widening": true
			}
			requiresWitnesses: {
				"deliverables-trace-to-kernel": true
			}
		}
	}

	gates: {
		"kernel-vocabulary-only": {
			description: "After the theory boundary, the module is expressed with Resource, Operation, Gate, Witness, ObligationState, and optional kernel patterns."
		}
		"semantic-preservation": {
			description: "The lattice projection preserves the Git theory invariants for selected linear history."
		}
		"closed-kernel-shape": {
			description: "The CUE surface closes through lat.#MakeClosedObligationState."
		}
		"no-local-ontology": {
			description: "The module does not define a parallel local schema for theory, lattice, workflow, adapter, or deliverable metadata."
		}
		"no-deliverable-widening": {
			description: "Workflow, adapter, and CUE tool deliverables do not exceed the contract resources, operations, gates, and witnesses."
		}
	}

	witnesses: {
		"linear-history-invariants": {
			description: "The theory states ref resolution, non-empty selected history, newest-is-ref-target, zero-or-one selected parents, root boundary, stable commit identity, and metadata availability."
		}
		"kernel-import": {
			description: "The contract imports github.com/fatb4f/lattice/meta and refines lat.#ObligationState directly."
		}
		"deliverables-trace-to-kernel": {
			description: "Each deliverable is described as a kernel resource, operation, gate, witness, or closed-state validation concern."
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
