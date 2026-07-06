package gitbasics

chapter: {
	id:    "02"
	title: "Git Basics"
	layers: {
		proGit:   "chapter order and vocabulary"
		gitKatas: "upstream exercise source and fixture situations"
		cue:      "authoritative micro-kata contract"
	}
	stateMachine: ["working-tree", "index", "commit", "history", "refs", "remote-refs", "tags"]
	sections: [
		{
			id:   "02.01"
			name: "getting-a-repository"
			kind: "setup"
			upstream: ["setup", "new"]
			micro: ["init-empty-repo", "clone-existing-repo", "locate-git-dir"]
		},
		{
			id:   "02.02"
			name: "recording-changes"
			kind: "mutation"
			upstream: ["basic-staging", "basic-commits", "ignore"]
			micro: ["observe-untracked-file", "stage-new-file", "commit-staged-file", "modify-tracked-file", "stage-modification", "ignore-file", "remove-tracked-file"]
		},
		{
			id:   "02.03"
			name: "viewing-history"
			kind: "inspection"
			upstream: ["basic-commits", "basic-staging", "basic-branching", "ff-merge", "3-way-merge", "git-tag", "investigation", "bisect", "Objects"]
			micro: ["linear-history", "compact-history", "limit-history", "patch-history", "stat-history", "name-status-history", "path-limited-history", "graph-history", "merge-filter-history", "message-author-date-filter", "pickaxe-history", "tag-decorated-history", "history-query-composition"]
		},
		{
			id:   "02.04"
			name: "undoing-things"
			kind: "mutation/recovery"
			upstream: ["amend", "reset", "basic-revert", "save-my-commit"]
			micro: ["amend-last-commit", "unstage-file", "restore-working-tree-file", "revert-commit", "reset-soft", "reset-mixed", "reset-hard"]
		},
		{
			id:   "02.05"
			name: "remotes"
			kind: "distributed"
			upstream: ["new", "remote-related"]
			micro: ["add-remote", "fetch-remote", "push-branch", "pull-branch", "inspect-tracking-branch"]
		},
		{
			id:   "02.06"
			name: "tagging"
			kind: "refs"
			upstream: ["git-tag"]
			micro: ["create-lightweight-tag", "create-annotated-tag", "show-tag", "checkout-tag", "compare-tag-range"]
		},
	]
}
