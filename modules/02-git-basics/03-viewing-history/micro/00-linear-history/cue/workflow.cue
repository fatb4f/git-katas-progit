package cuetool

import schema "example.com/git-katas-progit/schema:schema"

workflow: schema.#CueGitAnalysisWorkflow & {
	id: "cue.git.history.linear-provenance"

	analysis: {
		theoryRef: "scm.history.linear-provenance"
		latticeRef: "lattice.history.linear-provenance"
	}

	input: {
		repoPath: "."
		ref: "HEAD"
	}

	collectors: [
		{
			id: "resolve-head"
			adapter: "git"
			argv: ["git", "rev-parse", "HEAD"]
			produces: ["head-ref"]
		},
		{
			id: "collect-history-metadata"
			adapter: "git"
			argv: ["git", "log", "--format=%H%x09%P%x09%an <%ae>%x09%s"]
			produces: [
				"reachable-commit-list",
				"commit-parent-map",
				"commit-author-map",
				"commit-subject-map",
			]
		},
		{
			id: "collect-worktree-status"
			adapter: "git"
			argv: ["git", "status", "--porcelain=v1"]
			produces: ["worktree-status"]
		},
	]

	evidence: evidence
	report: report
}
