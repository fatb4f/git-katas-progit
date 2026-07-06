package viewinghistory

import meta "example.com/git-katas-progit/contracts:meta"

#MicroKata: {
	id:    string
	name:  string
	kind:  "git-cue"
	level: "L1" | "L2" | "L3"

	source: {
		upstream: [...string]
		proGit: string
		cue:    string
	}

	git: {
		objective: string
		commands: [...string]
		readModel: string
		decision:  string
		concepts: [...string]
		fixture: {
			name:  string
			shape: string
		}
	}

	cue: {
		objective:      string
		latticeProblem: string
		requiredPatterns: [...string]
		obligation: meta.#ObligationState
		closed: (meta.#MakeClosedObligationState & {in: obligation}).out
		expectedEval: "pass" | "fail" | "mixed"
	}

	evidence: {
		outputs: [...string]
		witnesses: [...string]
	}

	verify: {
		mode: "answer" | "cue-eval" | "mixed"
		checks: [...string]
	}
}

#CommonResources: {
	[string]: _
	"fixture-state": {path: "fixture-notes.md", role: "fixture", ...}
	"task-brief": {path: "task.md", role: "task", ...}
	"git-history-output": {path: "stdout", role: "observed-output", ...}
	"answer-evidence": {path: ".answers", role: "generated-output", ...}
}

#CommonGates: {
	[string]: _
	"read-only-history": {description: "The workflow may inspect history but must not mutate refs, index, worktree, or existing commits.", ...}
	"fixture-shape-present": {description: "The prepared repository fixture has the topology and metadata expected by the kata.", ...}
	"evidence-complete": {description: "All required answer witnesses are present before the workflow is promoted.", ...}
}

#CommonPatterns: [
	"constructors",
	"closedness",
	"unification",
	"negative-fixtures",
	"projections",
]

micro: [...#MicroKata] & [
	{
		id:    "02.03.00"
		name:  "linear-history"
		kind:  "git-cue"
		level: "L1"
		source: {upstream: ["basic-commits"], proGit: "Git Basics / Viewing the Commit History", cue: "constructors, closedness, witnesses"}
		git: {
			objective: "Inspect a linear commit graph and extract provenance before acting on the repository."
			commands: ["git log"]
			readModel: "reverse chronological commit metadata"
			decision:  "Determine newest and oldest commits plus newest commit provenance."
			concepts: ["commit", "hash", "author", "date", "message", "reverse chronological order"]
			fixture: {name: "linear-5", shape: "five commits on one branch"}
		}
		cue: {
			objective:        "Close an obligation state proving the linear-history inspection is read-only and fully witnessed."
			latticeProblem:   "Refine an unwitnessed repository fixture into a closed provenance decision."
			requiredPatterns: #CommonPatterns
			obligation: {
				id:        "linear-history-control"
				resources: #CommonResources
				operations: "inspect-linear-history": {
					kind:        "git-history-query"
					description: "Read the reachable linear commit history with git log and record provenance evidence."
					reads: {"fixture-state": true, "task-brief": true, "git-history-output": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true}
					requiresWitnesses: {"newest-commit": true, "oldest-commit": true, "author-field": true, "commit-subject": true}
				}
				gates: #CommonGates
				witnesses: {
					"newest-commit": {description: "The newest reachable commit hash is recorded."}
					"oldest-commit": {description: "The oldest reachable commit hash is recorded."}
					"author-field": {description: "The newest commit author field is recorded."}
					"commit-subject": {description: "The newest commit subject is recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/newest_commit", ".answers/oldest_commit", ".answers/author_field", ".answers/commit_subject"], witnesses: ["newest-commit", "oldest-commit", "author-field", "commit-subject"]}
		verify: {mode: "mixed", checks: ["newest_commit", "oldest_commit", "author_field", "commit_subject", "cue.closed"]}
	},
	{
		id:    "02.03.01"
		name:  "compact-history"
		kind:  "git-cue"
		level: "L1"
		source: {upstream: ["basic-commits"], proGit: "Git Basics / Viewing the Commit History", cue: "bounded projection, closedness, witnesses"}
		git: {
			objective: "Produce a bounded recent-history scan before deeper inspection."
			commands: ["git log --oneline", "git log --oneline -3"]
			readModel: "short hash and subject projection"
			decision:  "Map compact commit records and identify the latest three subjects."
			concepts: ["short hash", "subject", "output compression", "range limiting"]
			fixture: {name: "linear-5", shape: "five commits on one branch"}
		}
		cue: {
			objective:        "Model a compact history projection with explicit bounded-output witnesses."
			latticeProblem:   "Refine full history into a closed recent-history scan."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "compact-history-control"
				resources: #CommonResources & {"bounded-log-output": {path: "stdout", role: "observed-output"}}
				operations: "inspect-compact-history": {
					kind:        "git-history-query"
					description: "Read compact history and bounded latest-three output."
					reads: {"fixture-state": true, "task-brief": true, "git-history-output": true, "bounded-log-output": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "query-scope-bounded": true}
					requiresWitnesses: {"short-hash-map": true, "latest-three-subjects": true}
				}
				gates: #CommonGates & {"query-scope-bounded": {description: "The scan includes the explicit latest-three bound."}}
				witnesses: {
					"short-hash-map": {description: "Short hashes are mapped to subjects."}
					"latest-three-subjects": {description: "The three newest subjects are recorded newest first."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/short_hashes", ".answers/latest_three_subjects"], witnesses: ["short-hash-map", "latest-three-subjects"]}
		verify: {mode: "mixed", checks: ["short_hashes", "latest_three_subjects", "cue.closed"]}
	},
	{
		id:    "02.03.02"
		name:  "limit-history"
		kind:  "git-cue"
		level: "L1"
		source: {upstream: ["new bridge kata"], proGit: "Git Basics / Viewing the Commit History", cue: "bounded constraints, projections"}
		git: {
			objective: "Select commits by count and date bounds for a controlled history slice."
			commands: ["git log -2", "git log --since=\"2024-01-03\"", "git log --until=\"2024-01-03\""]
			readModel: "count-limited and date-limited commit metadata"
			decision:  "Determine which commits satisfy each independent history bound."
			concepts: ["history slice", "date filter", "count limit"]
			fixture: {name: "linear-5", shape: "five commits with controlled dates"}
		}
		cue: {
			objective:        "Encode independent count and date gates for bounded history selection."
			latticeProblem:   "Refine a complete linear history into count, since-date, and until-date projections."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "limit-history-control"
				resources: #CommonResources & {"date-metadata": {path: "fixture-notes.md", role: "fixture"}}
				operations: "inspect-limited-history": {
					kind:        "git-history-query"
					description: "Read count-limited and date-limited history projections."
					reads: {"fixture-state": true, "task-brief": true, "git-history-output": true, "date-metadata": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "query-scope-bounded": true}
					requiresWitnesses: {"latest-two-commits": true, "commits-after-date": true, "commits-before-date": true}
				}
				gates: #CommonGates & {"query-scope-bounded": {description: "Each answer is tied to the declared count or date bound."}}
				witnesses: {
					"latest-two-commits": {description: "Commits selected by the count bound are recorded."}
					"commits-after-date": {description: "Commits selected by the since-date bound are recorded."}
					"commits-before-date": {description: "Commits selected by the until-date bound are recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/latest_two_commits", ".answers/commits_after_date", ".answers/commits_before_date"], witnesses: ["latest-two-commits", "commits-after-date", "commits-before-date"]}
		verify: {mode: "mixed", checks: ["latest_two_commits", "commits_after_date", "commits_before_date", "cue.closed"]}
	},
	{
		id:    "02.03.03"
		name:  "patch-history"
		kind:  "git-cue"
		level: "L1"
		source: {upstream: ["basic-commits", "amend", "basic-revert"], proGit: "Git Basics / Viewing the Commit History", cue: "witness strength, negative fixtures"}
		git: {
			objective: "Identify where a line-level change entered or left history."
			commands: ["git log -p", "git show"]
			readModel: "patch hunks associated with commits"
			decision:  "Select commits that added and removed the target line."
			concepts: ["patch", "diff", "added line", "removed line"]
			fixture: {name: "linear-5", shape: "commits with small text changes"}
		}
		cue: {
			objective:        "Require patch-derived witnesses rather than metadata-only evidence."
			latticeProblem:   "Refine commit metadata into patch-hunk evidence."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "patch-history-control"
				resources: #CommonResources & {"patch-output": {path: "stdout", role: "observed-output"}}
				operations: "inspect-patch-history": {
					kind:        "git-history-query"
					description: "Read patch hunks and record add/remove evidence for the target line."
					reads: {"fixture-state": true, "task-brief": true, "patch-output": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "patch-evidence-required": true}
					requiresWitnesses: {"commit-that-added-line": true, "commit-that-removed-line": true}
				}
				gates: #CommonGates & {"patch-evidence-required": {description: "The decision must be justified by patch hunks, not subject text alone."}}
				witnesses: {
					"commit-that-added-line": {description: "The commit adding the target line is recorded."}
					"commit-that-removed-line": {description: "The commit removing the target line is recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/commit_that_added_line", ".answers/commit_that_removed_line"], witnesses: ["commit-that-added-line", "commit-that-removed-line"]}
		verify: {mode: "mixed", checks: ["commit_that_added_line", "commit_that_removed_line", "cue.closed"]}
	},
	{
		id:    "02.03.04"
		name:  "stat-history"
		kind:  "git-cue"
		level: "L1"
		source: {upstream: ["basic-staging"], proGit: "Git Basics / Viewing the Commit History", cue: "projections, witnesses"}
		git: {
			objective: "Use change-volume summaries to prioritize deeper audit."
			commands: ["git log --stat", "git log --shortstat"]
			readModel: "file and line-count summaries"
			decision:  "Identify high-volume commits and commits with deletions."
			concepts: ["change volume", "file summary", "insertions", "deletions"]
			fixture: {name: "file-evolution", shape: "several commits touching multiple files"}
		}
		cue: {
			objective:        "Encode stat output as summary evidence for audit triage."
			latticeProblem:   "Refine raw history into volume and deletion witnesses."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "stat-history-control"
				resources: #CommonResources & {"stat-output": {path: "stdout", role: "observed-output"}}
				operations: "inspect-stat-history": {
					kind:        "git-history-query"
					description: "Read stat summaries and record audit triage evidence."
					reads: {"fixture-state": true, "task-brief": true, "stat-output": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true}
					requiresWitnesses: {"largest-commit-by-files": true, "commit-with-deletions": true}
				}
				gates: #CommonGates
				witnesses: {
					"largest-commit-by-files": {description: "The commit touching the most files is recorded."}
					"commit-with-deletions": {description: "A commit containing deletions is recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/largest_commit_by_files", ".answers/commit_with_deletions"], witnesses: ["largest-commit-by-files", "commit-with-deletions"]}
		verify: {mode: "mixed", checks: ["largest_commit_by_files", "commit_with_deletions", "cue.closed"]}
	},
	{
		id:    "02.03.05"
		name:  "name-status-history"
		kind:  "git-cue"
		level: "L1"
		source: {upstream: ["basic-staging", "ignore", "git-rm"], proGit: "Git Basics / Viewing the Commit History", cue: "projections, witnesses"}
		git: {
			objective: "Classify path-level file lifecycle changes before audit or recovery work."
			commands: ["git log --name-only", "git log --name-status"]
			readModel: "path and status projections"
			decision:  "Separate added, modified, and deleted file events."
			concepts: ["path", "add", "modify", "delete", "rename preview"]
			fixture: {name: "file-evolution", shape: "files added modified and deleted"}
		}
		cue: {
			objective:        "Model file lifecycle classification as witnessed path-status evidence."
			latticeProblem:   "Refine commit history into add/modify/delete path events."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "name-status-history-control"
				resources: #CommonResources & {"name-status-output": {path: "stdout", role: "observed-output"}}
				operations: "inspect-name-status-history": {
					kind:        "git-history-query"
					description: "Read name/status projections and record file lifecycle evidence."
					reads: {"fixture-state": true, "task-brief": true, "name-status-output": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true}
					requiresWitnesses: {"added-file-commit": true, "deleted-file-commit": true, "modified-file-commits": true}
				}
				gates: #CommonGates
				witnesses: {
					"added-file-commit": {description: "A commit adding a file is recorded."}
					"deleted-file-commit": {description: "A commit deleting a file is recorded."}
					"modified-file-commits": {description: "Commits modifying files are recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/added_file_commit", ".answers/deleted_file_commit", ".answers/modified_file_commits"], witnesses: ["added-file-commit", "deleted-file-commit", "modified-file-commits"]}
		verify: {mode: "mixed", checks: ["added_file_commit", "deleted_file_commit", "modified_file_commits", "cue.closed"]}
	},
	{
		id:    "02.03.06"
		name:  "path-limited-history"
		kind:  "git-cue"
		level: "L2"
		source: {upstream: ["basic-staging", "investigation"], proGit: "Git Basics / Viewing the Commit History", cue: "scope gates, negative fixtures"}
		git: {
			objective: "Prove file-specific history before ownership, debugging, or revert decisions."
			commands: ["git log -- app/config.txt"]
			readModel: "pathspec-filtered commit history"
			decision:  "List only commits touching the target path and identify excluded unrelated history."
			concepts: ["pathspec", "file history", "filtered reachability"]
			fixture: {name: "file-evolution", shape: "one file changed in non-consecutive commits"}
		}
		cue: {
			objective:        "Require an explicit path-scope gate for the history query."
			latticeProblem:   "Refine whole-repo history into path-scoped evidence."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "path-limited-history-control"
				resources: #CommonResources & {"target-path": {path: "app/config.txt", role: "pathspec"}}
				operations: "inspect-path-history": {
					kind:        "git-history-query"
					description: "Read history constrained to app/config.txt and record included and excluded commits."
					reads: {"fixture-state": true, "task-brief": true, "git-history-output": true, "target-path": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "query-scope-bounded": true}
					requiresWitnesses: {"only-commits-touching-path": true, "excluded-unrelated-commit": true}
				}
				gates: #CommonGates & {"query-scope-bounded": {description: "The history query is constrained to the target pathspec."}}
				witnesses: {
					"only-commits-touching-path": {description: "Only commits touching app/config.txt are recorded."}
					"excluded-unrelated-commit": {description: "An unrelated commit excluded by the pathspec is recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/only_commits_touching_path", ".answers/excluded_unrelated_commit"], witnesses: ["only-commits-touching-path", "excluded-unrelated-commit"]}
		verify: {mode: "mixed", checks: ["only_commits_touching_path", "excluded_unrelated_commit", "cue.closed"]}
	},
	{
		id:    "02.03.07"
		name:  "graph-history"
		kind:  "git-cue"
		level: "L2"
		source: {upstream: ["basic-branching", "ff-merge", "3-way-merge"], proGit: "Git Basics / Viewing the Commit History", cue: "graph resources, promotion gates"}
		git: {
			objective: "Understand branch topology before merge, rebase, or revert decisions."
			commands: ["git log --graph --oneline --decorate --all"]
			readModel: "decorated commit graph"
			decision:  "Identify HEAD, branch tips, and the merge commit."
			concepts: ["DAG", "branch tip", "HEAD", "decoration", "reachability"]
			fixture: {name: "branch-merge", shape: "two branches and one merge commit"}
		}
		cue: {
			objective:        "Represent refs and graph topology as required promotion evidence."
			latticeProblem:   "Refine a commit list into topology-aware branch evidence."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "graph-history-control"
				resources: #CommonResources & {"decorated-graph-output": {path: "stdout", role: "observed-output"}, "refs": {path: ".git/refs", role: "git-ref"}}
				operations: "inspect-graph-history": {
					kind:        "git-history-query"
					description: "Read decorated graph output and record branch topology evidence."
					reads: {"fixture-state": true, "task-brief": true, "decorated-graph-output": true, "refs": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "topology-evidence-required": true}
					requiresWitnesses: {"head-branch": true, "branch-tips": true, "merge-commit": true}
				}
				gates: #CommonGates & {"topology-evidence-required": {description: "The decision must use decorated graph topology, not a flat commit list."}}
				witnesses: {
					"head-branch": {description: "The HEAD branch is recorded."}
					"branch-tips": {description: "Branch tip refs are recorded."}
					"merge-commit": {description: "The merge commit is recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/head_branch", ".answers/branch_tips", ".answers/merge_commit"], witnesses: ["head-branch", "branch-tips", "merge-commit"]}
		verify: {mode: "mixed", checks: ["head_branch", "branch_tips", "merge_commit", "cue.closed"]}
	},
	{
		id:    "02.03.08"
		name:  "merge-filter-history"
		kind:  "git-cue"
		level: "L2"
		source: {upstream: ["3-way-merge", "merge-conflict", "reverted-merge"], proGit: "Git Basics / Viewing the Commit History", cue: "classification gates, negative fixtures"}
		git: {
			objective: "Distinguish merge commits from ordinary commits before auditing integration history."
			commands: ["git log --merges", "git log --no-merges", "git show --summary"]
			readModel: "merge-filtered and non-merge commit sets"
			decision:  "Separate merge commits, identify merge parents, and count non-merge commits."
			concepts: ["merge commit", "parent commit", "first parent", "second parent"]
			fixture: {name: "branch-merge", shape: "normal commits plus merge commit"}
		}
		cue: {
			objective:        "Encode merge classification and parent evidence as required witnesses."
			latticeProblem:   "Refine mixed history into integration and ordinary commit evidence."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "merge-filter-history-control"
				resources: #CommonResources & {"merge-output": {path: "stdout", role: "observed-output"}, "parent-summary": {path: "stdout", role: "observed-output"}}
				operations: "inspect-merge-filter-history": {
					kind:        "git-history-query"
					description: "Read merge-filtered history and summary output to record integration evidence."
					reads: {"fixture-state": true, "task-brief": true, "merge-output": true, "parent-summary": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "merge-classification-required": true}
					requiresWitnesses: {"merge-commit": true, "merge-parents": true, "non-merge-count": true}
				}
				gates: #CommonGates & {"merge-classification-required": {description: "Integration evidence must distinguish merge commits from ordinary commits."}}
				witnesses: {
					"merge-commit": {description: "The merge commit is recorded."}
					"merge-parents": {description: "The merge parents are recorded."}
					"non-merge-count": {description: "The non-merge commit count is recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/merge_commit", ".answers/merge_parents", ".answers/non_merge_count"], witnesses: ["merge-commit", "merge-parents", "non-merge-count"]}
		verify: {mode: "mixed", checks: ["merge_commit", "merge_parents", "non_merge_count", "cue.closed"]}
	},
	{
		id:    "02.03.09"
		name:  "message-author-date-filter"
		kind:  "git-cue"
		level: "L2"
		source: {upstream: ["new bridge kata"], proGit: "Git Basics / Viewing the Commit History", cue: "metadata constraints, projections"}
		git: {
			objective: "Find history entries selected by metadata filters during review or release audit."
			commands: ["git log --grep=\"release\"", "git log --author=\"Ada\"", "git log --since=\"2024-01-02\" --until=\"2024-01-04\""]
			readModel: "message, author, and date metadata filters"
			decision:  "Identify commits matching author, message, and date-range constraints."
			concepts: ["metadata query", "author", "message", "date range"]
			fixture: {name: "metadata-varied", shape: "commits with varied authors dates and messages"}
		}
		cue: {
			objective:        "Represent independent metadata filters as separate witnessed constraints."
			latticeProblem:   "Refine history into author, message, and date-range result sets."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "message-author-date-filter-control"
				resources: #CommonResources & {"metadata": {path: "fixture-notes.md", role: "fixture"}}
				operations: "inspect-metadata-history": {
					kind:        "git-history-query"
					description: "Read metadata-filtered history and record each filter result."
					reads: {"fixture-state": true, "task-brief": true, "git-history-output": true, "metadata": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "metadata-filter-required": true}
					requiresWitnesses: {"author-matches": true, "message-matches": true, "date-range-matches": true}
				}
				gates: #CommonGates & {"metadata-filter-required": {description: "Each result set is tied to its declared metadata filter."}}
				witnesses: {
					"author-matches": {description: "Commits matching the author filter are recorded."}
					"message-matches": {description: "Commits matching the message filter are recorded."}
					"date-range-matches": {description: "Commits matching the date-range filter are recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/author_matches", ".answers/message_matches", ".answers/date_range_matches"], witnesses: ["author-matches", "message-matches", "date-range-matches"]}
		verify: {mode: "mixed", checks: ["author_matches", "message_matches", "date_range_matches", "cue.closed"]}
	},
	{
		id:    "02.03.10"
		name:  "pickaxe-history"
		kind:  "git-cue"
		level: "L3"
		source: {upstream: ["investigation", "bisect", "Bad-commit"], proGit: "Git Basics / Viewing the Commit History", cue: "semantic witnesses, negative fixtures"}
		git: {
			objective: "Locate semantic introduction and removal of a symbol."
			commands: ["git log -SfeatureFlag"]
			readModel: "pickaxe symbol occurrence changes"
			decision:  "Find commits where the target symbol is introduced and removed."
			concepts: ["pickaxe", "symbol introduction", "symbol removal", "occurrence count"]
			fixture: {name: "symbol-lifecycle", shape: "symbol introduced changed and removed"}
		}
		cue: {
			objective:        "Require semantic symbol-lifecycle witnesses distinct from path-level change evidence."
			latticeProblem:   "Refine file history into symbol introduction and removal evidence."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "pickaxe-history-control"
				resources: #CommonResources & {"target-symbol": {path: "featureFlag", role: "symbol"}, "pickaxe-output": {path: "stdout", role: "observed-output"}}
				operations: "inspect-pickaxe-history": {
					kind:        "git-history-query"
					description: "Read pickaxe output and record symbol lifecycle evidence."
					reads: {"fixture-state": true, "task-brief": true, "target-symbol": true, "pickaxe-output": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "semantic-evidence-required": true}
					requiresWitnesses: {"introduced-symbol-commit": true, "removed-symbol-commit": true}
				}
				gates: #CommonGates & {"semantic-evidence-required": {description: "The decision must be based on symbol occurrence changes."}}
				witnesses: {
					"introduced-symbol-commit": {description: "The commit introducing the target symbol is recorded."}
					"removed-symbol-commit": {description: "The commit removing the target symbol is recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/introduced_symbol_commit", ".answers/removed_symbol_commit"], witnesses: ["introduced-symbol-commit", "removed-symbol-commit"]}
		verify: {mode: "mixed", checks: ["introduced_symbol_commit", "removed_symbol_commit", "cue.closed"]}
	},
	{
		id:    "02.03.11"
		name:  "tag-decorated-history"
		kind:  "git-cue"
		level: "L2"
		source: {upstream: ["git-tag"], proGit: "Git Basics / Viewing the Commit History", cue: "ref boundaries, negative fixtures"}
		git: {
			objective: "Reason across release boundaries using refs rather than approximate dates."
			commands: ["git log --decorate", "git log v1.0..HEAD"]
			readModel: "tag-decorated and range-bounded history"
			decision:  "Identify the v1.0 tagged commit and commits after that tag."
			concepts: ["tag ref", "decoration", "range", "release boundary"]
			fixture: {name: "tagged-release", shape: "several commits with two tags"}
		}
		cue: {
			objective:        "Encode tag refs as the required release-boundary resource."
			latticeProblem:   "Refine chronological history into ref-bounded release history."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "tag-decorated-history-control"
				resources: #CommonResources & {"tag-ref": {path: "refs/tags/v1.0", role: "git-ref"}, "range-output": {path: "stdout", role: "observed-output"}}
				operations: "inspect-tag-decorated-history": {
					kind:        "git-history-query"
					description: "Read decorated history and range output to record release-boundary evidence."
					reads: {"fixture-state": true, "task-brief": true, "tag-ref": true, "range-output": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {"read-only-history": true, "fixture-shape-present": true, "evidence-complete": true, "ref-boundary-required": true}
					requiresWitnesses: {"tagged-commit": true, "commits-after-tag": true}
				}
				gates: #CommonGates & {"ref-boundary-required": {description: "The release boundary is the tag ref, not a date approximation."}}
				witnesses: {
					"tagged-commit": {description: "The commit tagged v1.0 is recorded."}
					"commits-after-tag": {description: "Commits reachable after v1.0 are recorded."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/tagged_commit", ".answers/commits_after_tag"], witnesses: ["tagged-commit", "commits-after-tag"]}
		verify: {mode: "mixed", checks: ["tagged_commit", "commits_after_tag", "cue.closed"]}
	},
	{
		id:    "02.03.12"
		name:  "history-query-composition"
		kind:  "git-cue"
		level: "L3"
		source: {upstream: ["new capstone"], proGit: "Git Basics / Viewing the Commit History", cue: "composition, gates, projection"}
		git: {
			objective: "Combine filters into a precise review/debug query."
			commands: ["git log v1.0..HEAD --graph --oneline --author=\"Ada\" --grep=\"release\" -- app/config.txt"]
			readModel: "range, graph, author, message, and path filtered history"
			decision:  "Explain why each result remains after all filters are applied."
			concepts: ["query composition", "shape", "range", "filter", "pathspec"]
			fixture: {name: "tagged-release", shape: "branch graph with tags authors messages and paths"}
		}
		cue: {
			objective:        "Compose multiple gates into one promotion-ready history query."
			latticeProblem:   "Refine independent constraints into a single validated query surface."
			requiredPatterns: #CommonPatterns
			obligation: {
				id: "history-query-composition-control"
				resources: #CommonResources & {
					"tag-ref": {path: "refs/tags/v1.0", role: "git-ref"}
					"target-path": {path: "app/config.txt", role: "pathspec"}
					"metadata": {path: "fixture-notes.md", role: "fixture"}
					"decorated-graph-output": {path: "stdout", role: "observed-output"}
				}
				operations: "inspect-composed-history": {
					kind:        "git-history-query"
					description: "Read one composed range, graph, author, message, and path query and record result evidence."
					reads: {"fixture-state": true, "task-brief": true, "tag-ref": true, "target-path": true, "metadata": true, "decorated-graph-output": true}
					writes: {"answer-evidence": true}
					creates: {}
					requiresGates: {
						"read-only-history":          true
						"fixture-shape-present":      true
						"evidence-complete":          true
						"ref-boundary-required":      true
						"query-scope-bounded":        true
						"metadata-filter-required":   true
						"topology-evidence-required": true
					}
					requiresWitnesses: {"composed-query-result": true, "explain-filter-chain": true}
				}
				gates: #CommonGates & {
					"ref-boundary-required": {description: "The range begins at the v1.0 tag ref."}
					"query-scope-bounded": {description: "The query is constrained to the target pathspec."}
					"metadata-filter-required": {description: "Author and message filters are part of the query contract."}
					"topology-evidence-required": {description: "The graph shape is preserved in the output."}
				}
				witnesses: {
					"composed-query-result": {description: "The commits returned by the composed query are recorded."}
					"explain-filter-chain": {description: "The contribution of each filter is explained."}
				}
			}
			expectedEval: "pass"
		}
		evidence: {outputs: [".answers/composed_query_result", ".answers/explain_filter_chain"], witnesses: ["composed-query-result", "explain-filter-chain"]}
		verify: {mode: "mixed", checks: ["composed_query_result", "explain_filter_chain", "cue.closed"]}
	},
]
