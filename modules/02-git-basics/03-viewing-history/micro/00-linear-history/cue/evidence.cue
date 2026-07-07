package cuetool

import schema "example.com/git-katas-progit/schema:schema"

evidence: schema.#EvidenceShape & {
	facts: {
		"head-ref": {
			id: "head-ref"
			description: "Resolved selected ref."
			source: {collector: "resolve-head", binding: "head-ref"}
			value: {kind: "scalar", format: "git/object-id", description: "Full commit object id."}
		}
		"reachable-commit-list": {
			id: "reachable-commit-list"
			description: "Observed selected history ordered newest first."
			source: {collector: "collect-linear-history", binding: "reachable-commit-list"}
			value: {kind: "list", format: "git/object-id", description: "Ordered list of full commit object ids."}
		}
		"commit-parent-map": {
			id: "commit-parent-map"
			description: "Observed parent relations for each selected commit."
			source: {collector: "collect-linear-history", binding: "commit-parent-map"}
			value: {kind: "map", format: "application/json", description: "Commit id to zero-or-one parent id for a linear scope."}
		}
		"commit-author-map": {
			id: "commit-author-map"
			description: "Observed author metadata for each selected commit."
			source: {collector: "collect-linear-history", binding: "commit-author-map"}
			value: {kind: "map", format: "application/json", description: "Commit id to author name and email."}
		}
		"commit-subject-map": {
			id: "commit-subject-map"
			description: "Observed subject metadata for each selected commit."
			source: {collector: "collect-linear-history", binding: "commit-subject-map"}
			value: {kind: "map", format: "application/json", description: "Commit id to subject line."}
		}
		"worktree-status": {
			id: "worktree-status"
			description: "Porcelain worktree status observed before analysis promotion."
			source: {collector: "check-read-only-state", binding: "worktree-status"}
			value: {kind: "list", format: "git/porcelain-v1", description: "Porcelain v1 status lines."}
		}
	}

	witnesses: {
		"newest-commit": {
			id: "newest-commit"
			description: "Newest selected object is the resolved ref."
			factRefs: ["head-ref", "reachable-commit-list"]
			derivation: {language: "cue", expression: "facts[\"reachable-commit-list\"][0] == facts[\"head-ref\"]", inputs: ["head-ref", "reachable-commit-list"]}
		}
		"oldest-commit": {
			id: "oldest-commit"
			description: "Oldest selected object is the terminal root in scope."
			factRefs: ["reachable-commit-list", "commit-parent-map"]
			derivation: {language: "adapter-native", expression: "git.linear.oldestRootInScope", inputs: ["reachable-commit-list", "commit-parent-map"]}
		}
		"newest-author": {
			id: "newest-author"
			description: "Newest commit author metadata."
			factRefs: ["head-ref", "commit-author-map"]
			derivation: {language: "cue", expression: "facts[\"commit-author-map\"][facts[\"head-ref\"]]", inputs: ["head-ref", "commit-author-map"]}
		}
		"newest-subject": {
			id: "newest-subject"
			description: "Newest commit subject metadata."
			factRefs: ["head-ref", "commit-subject-map"]
			derivation: {language: "cue", expression: "facts[\"commit-subject-map\"][facts[\"head-ref\"]]", inputs: ["head-ref", "commit-subject-map"]}
		}
		"linearity": {
			id: "linearity"
			description: "Selected history forms a single-parent chain."
			factRefs: ["reachable-commit-list", "commit-parent-map"]
			derivation: {language: "adapter-native", expression: "git.linear.singleParentChain", inputs: ["reachable-commit-list", "commit-parent-map"]}
		}
	}

	checks: {
		"head-resolves": {
			id: "head-resolves"
			description: "Selected ref resolves."
			requires: ["head-ref"]
			predicate: {language: "cue", expression: "facts[\"head-ref\"] =~ \"^[0-9a-f]{40}$\"", inputs: ["head-ref"]}
			onFailure: {bottomCase: "head-ref-unresolved", message: "selected ref did not resolve to a commit object id"}
		}
		"history-non-empty": {
			id: "history-non-empty"
			description: "Selected history contains records."
			requires: ["reachable-commit-list"]
			predicate: {language: "cue", expression: "len(facts[\"reachable-commit-list\"]) > 0", inputs: ["reachable-commit-list"]}
			onFailure: {bottomCase: "empty-selected-history", message: "selected scope produced no reachable commits"}
		}
		"newest-is-head": {
			id: "newest-is-head"
			description: "Newest record matches selected ref."
			requires: ["head-ref", "reachable-commit-list"]
			predicate: {language: "cue", expression: "facts[\"reachable-commit-list\"][0] == facts[\"head-ref\"]", inputs: ["head-ref", "reachable-commit-list"]}
			onFailure: {bottomCase: "evidence-divergence", message: "newest reachable commit does not match resolved ref"}
		}
		"oldest-is-root-in-scope": {
			id: "oldest-is-root-in-scope"
			description: "Oldest selected record has no selected parent."
			requires: ["reachable-commit-list", "commit-parent-map"]
			predicate: {language: "adapter-native", expression: "git.linear.oldestRootInScope", inputs: ["reachable-commit-list", "commit-parent-map"]}
			onFailure: {bottomCase: "evidence-divergence", message: "oldest witness is not the terminal commit in selected scope"}
		}
		"history-is-linear": {
			id: "history-is-linear"
			description: "Selected history has no merge commits."
			requires: ["commit-parent-map"]
			predicate: {language: "adapter-native", expression: "git.linear.noMergeParents", inputs: ["commit-parent-map"]}
			onFailure: {bottomCase: "linearity-violation", message: "selected history contains a merge topology"}
		}
		"metadata-present": {
			id: "metadata-present"
			description: "Required metadata is present."
			requires: ["commit-author-map", "commit-subject-map"]
			predicate: {language: "adapter-native", expression: "git.metadata.headAuthorAndSubjectPresent", inputs: ["head-ref", "commit-author-map", "commit-subject-map"]}
			onFailure: {bottomCase: "metadata-unavailable", message: "required author or subject metadata is unavailable"}
		}
		"analysis-read-only": {
			id: "analysis-read-only"
			description: "Analysis uses read-only Git collectors only."
			requires: ["worktree-status"]
			predicate: {language: "adapter-native", expression: "workflow.collectors.readOnly", inputs: ["worktree-status"]}
		}
	}

	bottomCases: {
		"head-ref-unresolved": {id: "head-ref-unresolved", description: "The selected ref cannot be resolved to a commit.", recoverability: "requires-input"}
		"empty-selected-history": {id: "empty-selected-history", description: "The selected scope yields no reachable commits.", recoverability: "requires-input"}
		"linearity-violation": {id: "linearity-violation", description: "The selected history has a merge topology where this analysis requires a single parent chain.", recoverability: "requires-input"}
		"metadata-unavailable": {id: "metadata-unavailable", description: "A required author or subject field cannot be projected from observed commit metadata.", recoverability: "terminal"}
		"evidence-divergence": {id: "evidence-divergence", description: "Derived evidence diverges from observed repository facts.", recoverability: "terminal"}
	}
}
