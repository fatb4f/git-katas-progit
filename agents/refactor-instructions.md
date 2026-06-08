# Agent Instructions — Refactor Existing Git Katas into Micro-Katas

## Mission

Transform existing `git-katas` exercises into a Pro Git-aligned curriculum of small, executable micro-katas.

Do not merely reorder folders. Extract the smallest useful learning contracts from each existing kata.

## Source Inputs

Use these as source material:

- existing kata README/task text
- existing setup scripts
- expected terminal commands
- hidden state transitions inside the exercise
- Pro Git chapter/section ordering

## Output Shape

Each generated micro-kata must contain:

```text
micro/<id>-<name>/
├── README.md
├── kata.cue
├── task.md
├── hints.md
├── verify.md
└── fixture-notes.md
```

Optional later:

```text
├── setup.go
├── verify.go
└── testdata/
```

## Rewrite Rules

### 1. Split by primitive

One micro-kata should teach exactly one Git primitive or one observable state invariant.

Good:

```text
stage-new-file
commit-staged-file
inspect-linear-history
reset-mixed
```

Bad:

```text
learn-basic-git
fix-the-repository
understand-branching
```

### 2. Split mutation from inspection

If an upstream kata asks the learner to both mutate and inspect state, split it.

Example:

```text
basic-commits
  -> recording-changes/01-stage-new-file
  -> recording-changes/02-commit-staged-file
  -> viewing-history/00-linear-history
  -> viewing-history/03-patch-history
```

### 3. Preserve upstream mapping

Every micro-kata must record its source material.

```cue
source: {
	upstream: ["basic-commits"]
	proGit: "Git Basics / Recording Changes to the Repository"
}
```

### 4. Declare verification mode

Use the narrowest verification mode possible.

| Mode | Use when |
|---|---|
| `state` | the learner must change repo state |
| `answer` | the learner must extract facts |
| `command-output` | the learner must produce/recognize output |
| `mixed` | recovery/debugging requires both state and answer |

### 5. Define success as invariants

Avoid vague success criteria.

Bad:

```text
Learner understands git log.
```

Good:

```text
Learner identifies newest commit hash, oldest commit hash, author, and subject.
```

### 6. Prefer fixture reuse

Do not create a new repository fixture for every micro-kata if one fixture can support several inspection tasks.

Example:

```text
fixture: linear-5-commits
  used by:
    02.03.00-linear-history
    02.03.01-compact-history
    02.03.02-limit-history
    02.03.03-patch-history
```

### 7. Preserve learner friction intentionally

Micro-katas should be small, not trivial. Each one should require the learner to run Git and observe state.

Do not turn katas into passive reading tasks.

## Micro-Kata Metadata Contract

```cue
kata: {
	id:    string
	name:  string
	kind:  "mutation" | "inspection" | "recovery" | "internals"
	level: "L1" | "L2" | "L3" | "L4" | "L5"

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
		prompt: string
		outputs: [...string]
	}

	verify: {
		mode:   "state" | "answer" | "command-output" | "mixed"
		checks: [...string]
	}
}
```

## Refactor Workflow

For each upstream kata:

1. Read the kata README and setup.
2. Extract all Git commands involved.
3. Identify the state transitions.
4. Identify the observations required to know the transition worked.
5. Split commands into one primitive per micro-kata.
6. Assign each micro-kata to a Pro Git section.
7. Add fixture contract.
8. Add verification contract.
9. Add source mapping.
10. Mark gaps as `new bridge kata` rather than forcing a bad mapping.

## Classification Guide

| Existing material | Target module |
|---|---|
| `basic-staging` | `02-git-basics/02-recording-changes` |
| `basic-commits` | `02-git-basics/02-recording-changes` and `02-git-basics/03-viewing-history` |
| `ignore` | `02-git-basics/02-recording-changes` |
| `amend` | `02-git-basics/04-undoing-things` and `07-git-tools/06-rewriting-history` |
| `reset` | `02-git-basics/04-undoing-things` and `07-git-tools/07-reset-demystified` |
| `basic-revert` | `02-git-basics/04-undoing-things` |
| `git-tag` | `02-git-basics/06-tagging` |
| `basic-branching` | `03-git-branching` and `02.03 viewing-history` inspection gates |
| `3-way-merge` | `03-git-branching` and `02.03 graph/merge history` |
| `bisect` | `07-git-tools/10-debugging` and `02.03 pickaxe bridge` |
| `Objects` | `10-git-internals` |

## Output Discipline

When generating files:

- keep task text short
- make commands explicit
- state the invariant being learned
- mark source material clearly
- avoid introducing advanced concepts before their Pro Git location unless the kata is explicitly a preview
