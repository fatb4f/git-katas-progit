package cuetool

import schema "example.com/git-katas-progit/schema:schema"

workflow: schema.#CueGitAnalysisWorkflow & {
	id: "cue.git.history.linear-provenance"

	analysis: {
		theoryRef: "scm.history.linear-provenance"
		latticeRef: "lattice.history.linear-provenance"
	}

	parameters: {
		repoPath: {type: "string", description: "Filesystem path to the Git repository under analysis."}
		ref: {type: "string", default: "HEAD", description: "Git ref or revision expression to analyze."}
	}

	input: {
		repoPath: "."
		ref: "HEAD"
	}

	collectors: [
		{
			id: "resolve-head"
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
			id: "collect-linear-history"
			adapter: "git"
			command: {
				executable: "git"
				args: ["log", "--format=%H%x09%P%x09%an <%ae>%x09%s", "{ref}"]
			}
			parsers: [
				{id: "linear-history-tsv", kind: "tsv", description: "Parse commit, parent list, author identity, and subject fields from git log output.", fields: ["commit", "parents", "author", "subject"]},
			]
			outputs: [
				{id: "reachable-commit-list", parser: "linear-history-tsv", fact: "reachable-commit-list"},
				{id: "commit-parent-map", parser: "linear-history-tsv", fact: "commit-parent-map"},
				{id: "commit-author-map", parser: "linear-history-tsv", fact: "commit-author-map"},
				{id: "commit-subject-map", parser: "linear-history-tsv", fact: "commit-subject-map"},
			]
		},
		{
			id: "check-read-only-state"
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

	evidence: evidence
	validate: {
		requiredFacts: [
			"head-ref",
			"reachable-commit-list",
			"commit-parent-map",
			"commit-author-map",
			"commit-subject-map",
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
			{id: "reachable-history-observed", description: "The selected ref has a non-empty reachable commit list.", requiresFacts: ["reachable-commit-list"], bottomCases: ["empty-selected-history"], promotesTo: "reachable commit set observed"}
			{id: "parent-map-observed", description: "The history parser emits parent information for each selected commit.", requiresFacts: ["commit-parent-map"], promotesTo: "parent map observed"}
			{id: "history-is-linear", description: "The selected commit set forms a single-parent chain.", requiresFacts: ["reachable-commit-list", "commit-parent-map"], requiresWitnesses: ["linearity"], bottomCases: ["linearity-violation"], promotesTo: "history is linear"}
			{id: "commit-metadata-observed", description: "The history parser emits author and subject metadata for selected commits.", requiresFacts: ["commit-author-map", "commit-subject-map"], bottomCases: ["metadata-unavailable"], promotesTo: "commit metadata observed"}
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
	report: report
	adapterContract: {
		parameters: ["repoPath", "ref"]
		facts: validate.requiredFacts
		witnesses: validate.requiredWitnesses
		checks: validate.checks
	}
}
