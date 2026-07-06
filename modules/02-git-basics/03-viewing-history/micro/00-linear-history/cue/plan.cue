package cuetool

import meta "example.com/git-katas-progit/contracts:meta"

plan: {
	id: "linear-history-tri-planar-migration"

	obligation: meta.#ObligationState & {
		id: "linear-history-tri-planar-migration"

		resources: {
			"constructor-kernel": {path: "contracts/constructors.cue", role: "authority"}
			"directory-schema": {path: "schema/directory.cue", role: "authority"}
			"kata-schema": {path: "schema/kata.cue", role: "authority"}
			"theory-schema": {path: "schema/theory.cue", role: "authority"}
			"lattice-schema": {path: "schema/lattice.cue", role: "authority"}
			"tool-schema": {path: "schema/cue_tool.cue", role: "authority"}
			"evidence-schema": {path: "schema/evidence.cue", role: "authority"}
			"report-schema": {path: "schema/report.cue", role: "authority"}
			"kata-directory": {path: "modules/02-git-basics/03-viewing-history/micro/00-linear-history", role: "mutation-target"}
			"theory-plane": {path: "modules/02-git-basics/03-viewing-history/micro/00-linear-history/theory", role: "generated-output"}
			"lattice-plane": {path: "modules/02-git-basics/03-viewing-history/micro/00-linear-history/lattice", role: "generated-output"}
			"micro-plane": {path: "modules/02-git-basics/03-viewing-history/micro/00-linear-history/micro", role: "generated-output"}
			"cue-plane": {path: "modules/02-git-basics/03-viewing-history/micro/00-linear-history/cue", role: "generated-output"}
			"evidence-shape": {path: "modules/02-git-basics/03-viewing-history/micro/00-linear-history/cue/evidence.cue", role: "generated-output"}
			"report-projection": {path: "modules/02-git-basics/03-viewing-history/micro/00-linear-history/cue/report.cue", role: "generated-output"}
		}

		operations: {
			"define-shared-schema": {
				kind: "create"
				description: "Define the shared kata directory, theory, lattice, workflow, evidence, and report schemas."
				reads: {"constructor-kernel": true}
				writes: {"directory-schema": true, "kata-schema": true, "theory-schema": true, "lattice-schema": true, "tool-schema": true, "evidence-schema": true, "report-schema": true}
				creates: {}
				requiresGates: {"schema-first": true, "constructor-backed": true}
				requiresWitnesses: {"shared-schema-surface": true}
			}
			"split-kata-directory": {
				kind: "edit"
				description: "Reshape the kata directory into theory, lattice, micro, and cue planes."
				reads: {"directory-schema": true, "kata-directory": true}
				writes: {"kata-directory": true}
				creates: {"theory-plane": true, "lattice-plane": true, "micro-plane": true, "cue-plane": true}
				requiresGates: {"tri-planar-shape": true, "no-embedded-kata-controller": true}
				requiresWitnesses: {"vertical-slice-created": true}
			}
			"shape-cue-workflow": {
				kind: "generate"
				description: "Operationalize the SCM analysis as a reusable CUE workflow with evidence and report projections."
				reads: {"tool-schema": true, "evidence-schema": true, "report-schema": true, "theory-plane": true, "lattice-plane": true}
				writes: {"cue-plane": true}
				creates: {"evidence-shape": true, "report-projection": true}
				requiresGates: {"reusable-scm-analysis-tool": true, "evidence-report-shaped": true}
				requiresWitnesses: {"cue-workflow-created": true, "evidence-shape-created": true, "report-projection-created": true}
			}
			"validate-constructor-closure": {
				kind: "validate"
				description: "Close this migration plan using the repository constructor kernel."
				reads: {"constructor-kernel": true, "cue-plane": true}
				writes: {}
				creates: {}
				requiresGates: {"constructor-backed": true}
				requiresWitnesses: {"closed-obligation-state": true}
			}
		}

		gates: {
			"schema-first": {description: "The refactor defines shared schema before per-kata projection."}
			"constructor-backed": {description: "Plan validation is expressed through contracts/constructors.cue."}
			"tri-planar-shape": {description: "The kata directory exposes theory, lattice, micro, and cue planes."}
			"no-embedded-kata-controller": {description: "The kata no longer uses local CUE as a lifecycle controller."}
			"reusable-scm-analysis-tool": {description: "The CUE plane resolves a reusable SCM repository-analysis class."}
			"evidence-report-shaped": {description: "The CUE plane shapes evidence and report outputs."}
		}

		witnesses: {
			"shared-schema-surface": {description: "Shared schemas are present under schema/."}
			"vertical-slice-created": {description: "The linear-history directory has theory, lattice, micro, and cue planes."}
			"cue-workflow-created": {description: "The CUE workflow is present in cue/workflow.cue."}
			"evidence-shape-created": {description: "The evidence shape is present in cue/evidence.cue."}
			"report-projection-created": {description: "The report projection is present in cue/report.cue."}
			"closed-obligation-state": {description: "The migration plan closes with #MakeClosedObligationState."}
		}
	}

	closed: (meta.#MakeClosedObligationState & {in: obligation}).out
}
