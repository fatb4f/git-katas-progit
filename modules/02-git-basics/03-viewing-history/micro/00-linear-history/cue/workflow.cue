package cuetool

workflow: #CueGitAnalysisWorkflow & {
	id: "cue.git.history.linear-provenance"

	analysis: {
		concept: "scm.history.linear-provenance"
		lattice: "lattice.history.linear-provenance"
	}

	parameters: {
		repoPath: {type: "string", description: "Filesystem path to the Git repository under analysis."}
		ref: {type: "string", default: "HEAD", description: "Git ref or revision expression to analyze."}
	}

	input: {
		repoPath: "."
		ref:      "HEAD"
	}

	collectors: [
		{
			id:      "resolve-head"
			adapter: "git"
			command: {
				executable: "git"
				args: ["rev-parse", "{ref}"]
			}
			parsers: [
				{id: "commit-id-line", kind: "line-regexp", description: "Capture one full Git object id from stdout.", pattern: "^[0-9a-f]{40}$", fields: ["objectId"]},
			]
			outputs: [
				{id: "head-ref", parser: "commit-id-line", fact: "head-ref"},
			]
		},
		{
			id:      "read-linear-history-payload"
			adapter: "process"
			command: {
				executable: "git-history-json"
				args: ["--repo", "{repoPath}", "--ref", "{ref}"]
			}
			parsers: [
				{id: "closed-linear-history-json", kind: "json", description: "Parse a ClosedLinearHistory payload shaped by the Git object ontology."},
			]
			outputs: [
				{id: "linear-history", parser: "closed-linear-history-json", fact: "linear-history"},
			]
		},
		{
			id:      "check-read-only-state"
			adapter: "git"
			command: {
				executable: "git"
				args: ["status", "--porcelain=v1"]
			}
			parsers: [
				{id: "porcelain-v1-lines", kind: "exact-text", description: "Preserve porcelain v1 status output as read-only repository context."},
			]
			outputs: [
				{id: "worktree-status", parser: "porcelain-v1-lines", fact: "worktree-status"},
			]
		},
	]

	evidence: #linearHistoryEvidence
	validate: {
		requiredFacts: [
			"head-ref",
			"linear-history",
			"worktree-status",
		]

		requiredWitnesses: [
			"newest-commit",
			"oldest-commit",
			"newest-author",
			"newest-subject",
			"linearity",
		]

		checks: [
			"head-resolves",
			"history-non-empty",
			"newest-is-head",
			"oldest-is-root-in-scope",
			"history-is-linear",
			"metadata-present",
			"analysis-read-only",
		]

		refinements: [
			{id: "repository-exists", description: "The adapter can execute read-only Git commands in the target repository.", requiresFacts: ["worktree-status"], bottomCases: ["head-ref-unresolved"], promotesTo: "repository exists"}
			{id: "head-resolves", description: "The selected ref resolves to one commit object.", requiresFacts: ["head-ref"], bottomCases: ["head-ref-unresolved"], promotesTo: "head ref resolves"}
			{id: "reachable-history-observed", description: "The selected ref has a non-empty ClosedLinearHistory commit list.", requiresFacts: ["linear-history"], bottomCases: ["empty-selected-history"], promotesTo: "reachable commit set observed"}
			{id: "object-ontology-unified", description: "Every observed commit unifies with the Git commit object constraint.", requiresFacts: ["linear-history"], bottomCases: ["metadata-unavailable"], promotesTo: "commit object ontology observed"}
			{id: "history-is-linear", description: "The selected commit set forms a single-parent chain under #LinearHistorySet.", requiresFacts: ["linear-history"], requiresWitnesses: ["linearity"], bottomCases: ["linearity-violation"], promotesTo: "history is linear"}
			{id: "commit-metadata-observed", description: "Newest commit author and subject are projected from #Commit metadata.", requiresFacts: ["linear-history"], bottomCases: ["metadata-unavailable"], promotesTo: "commit metadata observed"}
			{id: "boundary-commits-identified", description: "Newest and oldest commits are derived from the observed history boundary.", requiresWitnesses: ["newest-commit", "oldest-commit"], bottomCases: ["evidence-divergence"], promotesTo: "boundary commits identified"}
			{id: "provenance-witnesses-extracted", description: "Newest commit provenance witnesses are derived from metadata maps.", requiresWitnesses: ["newest-author", "newest-subject"], bottomCases: ["evidence-divergence"], promotesTo: "required witnesses extracted"}
		]

		bottomCases: [
			"head-ref-unresolved",
			"empty-selected-history",
			"linearity-violation",
			"metadata-unavailable",
			"evidence-divergence",
		]
		successState: "closed linear-history provenance evidence"
	}
	report: #linearHistoryReport
	adapterContract: {
		parameters: ["repoPath", "ref"]
		facts:     validate.requiredFacts
		witnesses: validate.requiredWitnesses
		checks:    validate.checks
	}
}
