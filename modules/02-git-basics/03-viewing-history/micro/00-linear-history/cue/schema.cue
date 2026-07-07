package cuetool

import "strings"

#NonEmptyString: string & strings.MinRunes(1)
#NonEmptyStringList: [...#NonEmptyString] & [_, ...]
#KebabIdentifier: #NonEmptyString & =~"^[a-z0-9]+(-[a-z0-9]+)*$"

#FactID:       #KebabIdentifier
#WitnessID:    #KebabIdentifier
#CheckID:      #KebabIdentifier
#BottomCaseID: #KebabIdentifier
#SHA1:         string & =~"^[0-9a-f]{40}$"

#Signature: {
	name:  #NonEmptyString
	email: #NonEmptyString
	time:  int
	tz:    string & =~"^[+-][0-9]{4}$"
}

#GitObject: {
	hash: #SHA1
	type: "blob" | "tree" | "commit" | "tag"
	size: int & >=0
	...
}

#Blob: #GitObject & {
	type: "blob"
}

#TreeEntry: {
	mode: string & =~"^[0-7]{6}$"
	type: "blob" | "tree" | "commit"
	hash: #SHA1
	name: #NonEmptyString
}

#Tree: #GitObject & {
	type: "tree"
	entries: [...#TreeEntry]
}

#Commit: #GitObject & {
	type: "commit"
	tree: #SHA1
	parents: [...#SHA1]
	author:    #Signature
	committer: #Signature
	message:   string
}

#AnnotatedTag: #GitObject & {
	type:       "tag"
	object:     #SHA1
	objectType: "blob" | "tree" | "commit" | "tag"
	tag:        #NonEmptyString
	tagger:     #Signature
	message:    string
}

#Reference: {
	name:   #NonEmptyString
	target: #SHA1
}

#HEAD: {
	detached: bool
	target:   #SHA1
	if detached == false {
		ref: #NonEmptyString
	}
}

#FileState: {
	path:        #NonEmptyString
	head_hash?:  #SHA1
	index_hash?: #SHA1
	work_hash?:  #SHA1
	status:      "untracked" | "modified" | "staged" | "clean" | "deleted"
}

#CleanFile: #FileState & {
	head_hash:  #SHA1
	index_hash: head_hash
	work_hash:  head_hash
	status:     "clean"
}

#StagedFile: #FileState & {
	head_hash:  #SHA1
	index_hash: #SHA1
	work_hash:  index_hash
	status:     "staged"
	_distinct:  true & (index_hash != head_hash)
}

#LinearHistorySet: {
	head: #SHA1
	commits: [...#Commit] & [_, ...]
	newest:    commits[0].hash
	is_linear: true
	_linearity: [for c in commits {true & (len(c.parents) <= 1)}]
}

#ClosedLinearHistory: {
	head:        #HEAD
	_headTarget: head.target
	history: #LinearHistorySet & {
		head: _headTarget
	}
	root: #Commit & {
		parents: []
	}
	witnesses: {
		newestCommit:  history.newest
		oldestCommit:  root.hash
		newestAuthor:  history.commits[0].author
		newestSubject: history.commits[0].message
		linearity:     history.is_linear
	}
}

#LinearHistoryFacts: {
	headRef: #SHA1
	linearHistory: #ClosedLinearHistory & {
		_headTarget: headRef
	}
	worktreeStatus?: [...string]
}

#ThreeTreesSnapshot: {
	head:  #Tree
	index: #Tree
	working: [...#FileState]
}

#AdapterKind: "git" | "cue" | "filesystem" | "process"
#StreamName:  "stdout" | "stderr" | "exit-code"
#ParserKind:  "exact-text" | "line-regexp" | "tsv" | "json" | "cue" | "adapter-native"

#CommandSpec: {
	executable: #NonEmptyString
	args: [...#NonEmptyString]
	cwd:       #NonEmptyString | *"{repoPath}"
	timeoutMs: int & >0 | *30000
}

#ParserSpec: {
	id:          #KebabIdentifier
	kind:        #ParserKind
	description: #NonEmptyString
	pattern?:    #NonEmptyString
	fields?:     #NonEmptyStringList
}

#ParameterSpec: {
	type:        "string" | "int" | "bool"
	required:    bool | *true
	default?:    #NonEmptyString
	description: #NonEmptyString
}

#OutputBinding: {
	id:     #KebabIdentifier
	stream: #StreamName | *"stdout"
	parser: #KebabIdentifier
	fact:   #FactID
}

#Collector: {
	id:      #KebabIdentifier
	adapter: #AdapterKind
	command: #CommandSpec
	parsers: [...#ParserSpec] & [_, ...]
	outputs: [...#OutputBinding] & [_, ...]
	produces: [for output in outputs {output.fact}]
	readOnly: bool | *true
}

#GitCollector: #Collector & {
	adapter: "git"
}

#DataShapeKind: "scalar" | "list" | "map" | "record" | "boolean"
#DataFormat:    "text/plain" | "application/json" | "application/x-cue" | "git/object-id" | "git/object" | "git/ref" | "git/history" | "git/porcelain-v1"
#Severity:      "error" | "warning" | "info"

#FactValueShape: {
	kind:        #DataShapeKind
	format:      #DataFormat
	description: #NonEmptyString
	schemaRef?:  #NonEmptyString
}

#FactSource: {
	collector: #KebabIdentifier
	binding:   #KebabIdentifier
}

#DerivationSpec: {
	language:   "cue" | "cel" | "adapter-native"
	expression: #NonEmptyString
	inputs:     #NonEmptyStringList
}

#PredicateSpec: {
	language:   "cue" | "cel" | "adapter-native"
	expression: #NonEmptyString
	inputs:     #NonEmptyStringList
}

#CheckFailure: {
	bottomCase: #BottomCaseID
	message:    #NonEmptyString
}

#BottomCaseSpec: {
	id:             #BottomCaseID
	description:    #NonEmptyString
	severity:       #Severity | *"error"
	recoverability: "retryable" | "requires-input" | "terminal"
}

#EvidenceFact: {
	id:          #FactID
	description: #NonEmptyString
	source:      #FactSource
	value:       #FactValueShape
	required:    bool | *true
}

#EvidenceWitness: {
	id:          #WitnessID
	description: #NonEmptyString
	factRefs:    #NonEmptyStringList
	derivation:  #DerivationSpec
	required:    bool | *true
}

#EvidenceCheck: {
	id:          #CheckID
	description: #NonEmptyString
	requires:    #NonEmptyStringList
	predicate:   #PredicateSpec
	onFailure?:  #CheckFailure
	severity:    #Severity | *"error"
}

#EvidenceShape: {
	facts: {
		[string]: #EvidenceFact
	}
	witnesses: {
		[string]: #EvidenceWitness
	}
	checks: {
		[string]: #EvidenceCheck
	}
	bottomCases: {
		[string]: #BottomCaseSpec
	}
}

#ReportSection: {
	id:          #KebabIdentifier
	title:       #NonEmptyString
	description: #NonEmptyString
	derivesFrom: #NonEmptyStringList
	render: {
		kind:        "table" | "list" | "object" | "paragraph"
		sourcePaths: #NonEmptyStringList
	}
}

#ReportProjection: {
	id:       #NonEmptyString
	format:   "markdown" | "json" | "cue"
	audience: "human" | "agent" | "api" | *"agent"
	sections: [...#ReportSection] & [_, ...]
}

#AnalysisRefinement: {
	id:                 #KebabIdentifier
	description:        #NonEmptyString
	requiresFacts?:     #NonEmptyStringList
	requiresWitnesses?: #NonEmptyStringList
	bottomCases?:       #NonEmptyStringList
	promotesTo:         #NonEmptyString
}

#AnalysisValidation: {
	requiredFacts:     #NonEmptyStringList
	requiredWitnesses: #NonEmptyStringList
	checks:            #NonEmptyStringList
	refinements: [...#AnalysisRefinement] & [_, ...]
	bottomCases:  #NonEmptyStringList
	successState: #NonEmptyString
}

#CuePatternChoice: {
	id:          #KebabIdentifier
	pattern:     #NonEmptyString
	useWhen:     #NonEmptyString
	why:         #NonEmptyString
	exampleRefs: #NonEmptyStringList
}

#CueLatticeRefinement: {
	id:          #KebabIdentifier
	from:        #NonEmptyString
	to:          #NonEmptyString
	patternRefs: #NonEmptyStringList
	why:         #NonEmptyString
}

#CueLatticeTheory: {
	id:       #NonEmptyString
	question: #NonEmptyString
	top:      #NonEmptyString
	refinements: [...#CueLatticeRefinement] & [_, ...]
	closedState: #NonEmptyString
	patterns: {
		[string]: #CuePatternChoice
	}
	bottomCases: {
		[string]: #NonEmptyString
	}
	antiPatterns: {
		[string]: #NonEmptyString
	}
	workflowMapping: {
		schema:     #NonEmptyStringList
		collectors: #NonEmptyStringList
		evidence:   #NonEmptyStringList
		validate:   #NonEmptyStringList
		report:     #NonEmptyStringList
	}
}

#CueGitAnalysisWorkflow: {
	id:      #NonEmptyString
	version: #NonEmptyString | *"v1"
	analysis: {
		concept: #NonEmptyString
		lattice: #NonEmptyString
	}
	parameters: {
		[string]: #ParameterSpec
	}
	input: {
		repoPath: #NonEmptyString
		ref:      #NonEmptyString | *"HEAD"
	}
	payload?: #LinearHistoryFacts
	collectors: [...#Collector] & [_, ...]
	evidence: #EvidenceShape
	validate: #AnalysisValidation
	report:   #ReportProjection
	adapterContract: {
		parameters: #NonEmptyStringList
		facts:      #NonEmptyStringList
		witnesses:  #NonEmptyStringList
		checks:     #NonEmptyStringList
	}
}
