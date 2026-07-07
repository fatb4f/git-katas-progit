package cuetool

#linearHistoryEvidence: #EvidenceShape & {
	facts: {
		"head-ref": {
			id:          "head-ref"
			description: "Resolved selected ref."
			source: {collector: "resolve-head", binding: "head-ref"}
			value: {kind: "scalar", format: "git/object-id", description: "Full commit object id."}
		}
		"linear-history": {
			id:          "linear-history"
			description: "Observed selected history as a ClosedLinearHistory payload."
			source: {collector: "read-linear-history-payload", binding: "linear-history"}
			value: {kind: "record", format: "git/history", schemaRef: "#ClosedLinearHistory", description: "Structured commit objects, HEAD, root boundary, and derived witnesses."}
		}
		"worktree-status": {
			id:          "worktree-status"
			description: "Porcelain worktree status observed before analysis promotion."
			source: {collector: "check-read-only-state", binding: "worktree-status"}
			value: {kind: "list", format: "git/porcelain-v1", description: "Porcelain v1 status lines."}
		}
	}

	witnesses: {
		"newest-commit": {
			id:          "newest-commit"
			description: "Newest selected object is projected from #ClosedLinearHistory."
			factRefs: ["head-ref", "linear-history"]
			derivation: {language: "cue", expression: "payload.linearHistory.witnesses.newestCommit == payload.headRef", inputs: ["head-ref", "linear-history"]}
		}
		"oldest-commit": {
			id:          "oldest-commit"
			description: "Oldest selected object is the root commit in the closed payload."
			factRefs: ["linear-history"]
			derivation: {language: "cue", expression: "payload.linearHistory.witnesses.oldestCommit == payload.linearHistory.root.hash", inputs: ["linear-history"]}
		}
		"newest-author": {
			id:          "newest-author"
			description: "Newest commit author metadata projected from #Commit."
			factRefs: ["linear-history"]
			derivation: {language: "cue", expression: "payload.linearHistory.witnesses.newestAuthor == payload.linearHistory.history.commits[0].author", inputs: ["linear-history"]}
		}
		"newest-subject": {
			id:          "newest-subject"
			description: "Newest commit subject metadata projected from #Commit."
			factRefs: ["linear-history"]
			derivation: {language: "cue", expression: "payload.linearHistory.witnesses.newestSubject == payload.linearHistory.history.commits[0].message", inputs: ["linear-history"]}
		}
		"linearity": {
			id:          "linearity"
			description: "Selected history forms a single-parent chain under #LinearHistorySet."
			factRefs: ["linear-history"]
			derivation: {language: "cue", expression: "payload.linearHistory.history.is_linear == true", inputs: ["linear-history"]}
		}
	}

	checks: {
		"head-resolves": {
			id:          "head-resolves"
			description: "Selected ref resolves."
			requires: ["head-ref"]
			predicate: {language: "cue", expression: "facts[\"head-ref\"] =~ \"^[0-9a-f]{40}$\"", inputs: ["head-ref"]}
			onFailure: {bottomCase: "head-ref-unresolved", message: "selected ref did not resolve to a commit object id"}
		}
		"history-non-empty": {
			id:          "history-non-empty"
			description: "Selected history contains records."
			requires: ["linear-history"]
			predicate: {language: "cue", expression: "len(payload.linearHistory.history.commits) > 0", inputs: ["linear-history"]}
			onFailure: {bottomCase: "empty-selected-history", message: "selected scope produced no reachable commits"}
		}
		"newest-is-head": {
			id:          "newest-is-head"
			description: "Newest record matches selected ref."
			requires: ["head-ref", "linear-history"]
			predicate: {language: "cue", expression: "payload.linearHistory.history.commits[0].hash == payload.headRef", inputs: ["head-ref", "linear-history"]}
			onFailure: {bottomCase: "evidence-divergence", message: "newest reachable commit does not match resolved ref"}
		}
		"oldest-is-root-in-scope": {
			id:          "oldest-is-root-in-scope"
			description: "Oldest selected record has no selected parent."
			requires: ["linear-history"]
			predicate: {language: "cue", expression: "len(payload.linearHistory.root.parents) == 0", inputs: ["linear-history"]}
			onFailure: {bottomCase: "evidence-divergence", message: "oldest witness is not the terminal commit in selected scope"}
		}
		"history-is-linear": {
			id:          "history-is-linear"
			description: "Selected history has no merge commits."
			requires: ["linear-history"]
			predicate: {language: "cue", expression: "payload.linearHistory.history._linearity", inputs: ["linear-history"]}
			onFailure: {bottomCase: "linearity-violation", message: "selected history contains a merge topology"}
		}
		"metadata-present": {
			id:          "metadata-present"
			description: "Required metadata is present."
			requires: ["linear-history"]
			predicate: {language: "cue", expression: "payload.linearHistory.history.commits[0].author & payload.linearHistory.history.commits[0].message", inputs: ["linear-history"]}
			onFailure: {bottomCase: "metadata-unavailable", message: "required author or subject metadata is unavailable"}
		}
		"analysis-read-only": {
			id:          "analysis-read-only"
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

evidence: #linearHistoryEvidence
