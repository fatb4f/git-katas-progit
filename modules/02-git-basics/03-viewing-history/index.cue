package viewinghistory

#MicroKata: {
	id:       string
	name:     string
	kind:     "inspection"
	level:    "L1" | "L2" | "L3"
	source: {
		upstream: [...string]
		proGit:   string
	}
	commands: [...string]
	concepts: [...string]
	fixture: {
		name:  string
		shape: string
	}
	task: {
		prompt:  string
		outputs: [...string]
	}
	verify: {
		mode:   "answer" | "command-output" | "mixed"
		checks: [...string]
	}
}

micro: [
	{
		id: "02.03.00"
		name: "linear-history"
		kind: "inspection"
		level: "L1"
		source: {upstream: ["basic-commits"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log"]
		concepts: ["commit", "hash", "author", "date", "message", "reverse chronological order"]
		fixture: {name: "linear-5", shape: "five commits on one branch"}
		task: {prompt: "Identify the newest commit, oldest commit, author field, and latest commit subject.", outputs: [".answers/newest_commit", ".answers/oldest_commit", ".answers/author_field", ".answers/commit_subject"]}
		verify: {mode: "answer", checks: ["newest_commit", "oldest_commit", "author_field", "commit_subject"]}
	},
	{
		id: "02.03.01"
		name: "compact-history"
		kind: "inspection"
		level: "L1"
		source: {upstream: ["basic-commits"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log --oneline", "git log --oneline -3"]
		concepts: ["short hash", "subject", "output compression", "range limiting"]
		fixture: {name: "linear-5", shape: "five commits on one branch"}
		task: {prompt: "Map short hashes to subjects and list the latest three subjects.", outputs: [".answers/short_hashes", ".answers/latest_three_subjects"]}
		verify: {mode: "answer", checks: ["short_hashes", "latest_three_subjects"]}
	},
	{
		id: "02.03.02"
		name: "limit-history"
		kind: "inspection"
		level: "L1"
		source: {upstream: ["new bridge kata"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log -2", "git log --since=\"2024-01-03\"", "git log --until=\"2024-01-03\""]
		concepts: ["history slice", "date filter", "count limit"]
		fixture: {name: "linear-5", shape: "five commits with controlled dates"}
		task: {prompt: "List commits selected by count, since-date, and until-date filters.", outputs: [".answers/latest_two_commits", ".answers/commits_after_date", ".answers/commits_before_date"]}
		verify: {mode: "answer", checks: ["latest_two_commits", "commits_after_date", "commits_before_date"]}
	},
	{
		id: "02.03.03"
		name: "patch-history"
		kind: "inspection"
		level: "L1"
		source: {upstream: ["basic-commits", "amend", "basic-revert"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log -p", "git show"]
		concepts: ["patch", "diff", "added line", "removed line"]
		fixture: {name: "linear-5", shape: "commits with small text changes"}
		task: {prompt: "Find the commit that added the target line and the commit that removed it.", outputs: [".answers/commit_that_added_line", ".answers/commit_that_removed_line"]}
		verify: {mode: "answer", checks: ["commit_that_added_line", "commit_that_removed_line"]}
	},
	{
		id: "02.03.04"
		name: "stat-history"
		kind: "inspection"
		level: "L1"
		source: {upstream: ["basic-staging"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log --stat", "git log --shortstat"]
		concepts: ["change volume", "file summary", "insertions", "deletions"]
		fixture: {name: "file-evolution", shape: "several commits touching multiple files"}
		task: {prompt: "Identify the commit with the largest file count and a commit that includes deletions.", outputs: [".answers/largest_commit_by_files", ".answers/commit_with_deletions"]}
		verify: {mode: "answer", checks: ["largest_commit_by_files", "commit_with_deletions"]}
	},
	{
		id: "02.03.05"
		name: "name-status-history"
		kind: "inspection"
		level: "L1"
		source: {upstream: ["basic-staging", "ignore", "git-rm"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log --name-only", "git log --name-status"]
		concepts: ["path", "add", "modify", "delete", "rename preview"]
		fixture: {name: "file-evolution", shape: "files added modified and deleted"}
		task: {prompt: "Classify commits that added, modified, and deleted files.", outputs: [".answers/added_file_commit", ".answers/deleted_file_commit", ".answers/modified_file_commits"]}
		verify: {mode: "answer", checks: ["added_file_commit", "deleted_file_commit", "modified_file_commits"]}
	},
	{
		id: "02.03.06"
		name: "path-limited-history"
		kind: "inspection"
		level: "L2"
		source: {upstream: ["basic-staging", "investigation"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log -- app/config.txt"]
		concepts: ["pathspec", "file history", "filtered reachability"]
		fixture: {name: "file-evolution", shape: "one file changed in non-consecutive commits"}
		task: {prompt: "List only commits touching the target path and identify an unrelated commit that is excluded.", outputs: [".answers/only_commits_touching_path", ".answers/excluded_unrelated_commit"]}
		verify: {mode: "answer", checks: ["only_commits_touching_path", "excluded_unrelated_commit"]}
	},
	{
		id: "02.03.07"
		name: "graph-history"
		kind: "inspection"
		level: "L2"
		source: {upstream: ["basic-branching", "ff-merge", "3-way-merge"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log --graph --oneline --decorate --all"]
		concepts: ["DAG", "branch tip", "HEAD", "decoration", "reachability"]
		fixture: {name: "branch-merge", shape: "two branches and one merge commit"}
		task: {prompt: "Read the graph output to identify HEAD, branch tips, and the merge commit.", outputs: [".answers/head_branch", ".answers/branch_tips", ".answers/merge_commit"]}
		verify: {mode: "answer", checks: ["head_branch", "branch_tips", "merge_commit"]}
	},
	{
		id: "02.03.08"
		name: "merge-filter-history"
		kind: "inspection"
		level: "L2"
		source: {upstream: ["3-way-merge", "merge-conflict", "reverted-merge"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log --merges", "git log --no-merges", "git show --summary"]
		concepts: ["merge commit", "parent commit", "first parent", "second parent"]
		fixture: {name: "branch-merge", shape: "normal commits plus merge commit"}
		task: {prompt: "Separate merge commits from ordinary commits and identify merge parents.", outputs: [".answers/merge_commit", ".answers/merge_parents", ".answers/non_merge_count"]}
		verify: {mode: "answer", checks: ["merge_commit", "merge_parents", "non_merge_count"]}
	},
	{
		id: "02.03.09"
		name: "message-author-date-filter"
		kind: "inspection"
		level: "L2"
		source: {upstream: ["new bridge kata"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log --grep=\"release\"", "git log --author=\"Ada\"", "git log --since=\"2024-01-02\" --until=\"2024-01-04\""]
		concepts: ["metadata query", "author", "message", "date range"]
		fixture: {name: "metadata-varied", shape: "commits with varied authors dates and messages"}
		task: {prompt: "Find commits selected by message, author, and date-range filters.", outputs: [".answers/author_matches", ".answers/message_matches", ".answers/date_range_matches"]}
		verify: {mode: "answer", checks: ["author_matches", "message_matches", "date_range_matches"]}
	},
	{
		id: "02.03.10"
		name: "pickaxe-history"
		kind: "inspection"
		level: "L3"
		source: {upstream: ["investigation", "bisect", "Bad-commit"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log -SfeatureFlag"]
		concepts: ["pickaxe", "symbol introduction", "symbol removal", "occurrence count"]
		fixture: {name: "symbol-lifecycle", shape: "symbol introduced changed and removed"}
		task: {prompt: "Find the commits where the target symbol is introduced and removed.", outputs: [".answers/introduced_symbol_commit", ".answers/removed_symbol_commit"]}
		verify: {mode: "answer", checks: ["introduced_symbol_commit", "removed_symbol_commit"]}
	},
	{
		id: "02.03.11"
		name: "tag-decorated-history"
		kind: "inspection"
		level: "L2"
		source: {upstream: ["git-tag"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log --decorate", "git log v1.0..HEAD"]
		concepts: ["tag ref", "decoration", "range", "release boundary"]
		fixture: {name: "tagged-release", shape: "several commits with two tags"}
		task: {prompt: "Identify the commit tagged as v1.0 and commits after that tag.", outputs: [".answers/tagged_commit", ".answers/commits_after_tag"]}
		verify: {mode: "answer", checks: ["tagged_commit", "commits_after_tag"]}
	},
	{
		id: "02.03.12"
		name: "history-query-composition"
		kind: "inspection"
		level: "L3"
		source: {upstream: ["new capstone"], proGit: "Git Basics / Viewing the Commit History"}
		commands: ["git log v1.0..HEAD --graph --oneline --author=\"Ada\" --grep=\"release\" -- app/config.txt"]
		concepts: ["query composition", "shape", "range", "filter", "pathspec"]
		fixture: {name: "tagged-release", shape: "branch graph with tags authors messages and paths"}
		task: {prompt: "Compose range, graph, author, message, and path filters, then explain why the result set matches.", outputs: [".answers/composed_query_result", ".answers/explain_filter_chain"]}
		verify: {mode: "mixed", checks: ["composed_query_result", "explain_filter_chain"]}
	},
]
