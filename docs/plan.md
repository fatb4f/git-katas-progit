
## Recommended sequence

```text
CUE contract surface
  ↓
git-katas-progit as controlled Git curriculum
  ↓
Rust as adapter/runtime skill
  ↓
gix/gitoxide read-only Git fact extractor
  ↓
semagrams datom lowering + CUE acceptance loop
```

Do **not** start with Rust or gitoxide. Start with the **contracts and invariants** that Rust/gitoxide will later satisfy.

---

## 0. Target architecture

```text
git-katas-progit
  └─ produces Git primitive cases
       ↓
gitfacts adapter, later Rust + gix
  └─ observes repo state/object/ref/index/history facts
       ↓
normalized datoms
  └─ { schema, kata, phase, datoms: [{ e, a, v, source }] }
       ↓
semagrams / patchplan
  ├─ imports facts
  ├─ derives graph/model/report JSON
  └─ CUE accepts or rejects candidate state
```

This matches the existing direction: `git-katas-progit` already frames learning as **Pro Git chapter → curriculum index → micro-kata contracts → fixture → task → verification gate**.  Its micro-kata rule is exactly the unit you need: **one Git primitive + one observable invariant**.

---

## 1. Phase A — CUE first: define the learning/control contract

**Goal:** make the learning plan itself machine-checkable.

Create a CUE package like:

```cue
package learning

#LearningUnit: {
	id: string
	layer: "cue" | "git" | "rust" | "gitoxide" | "semagrams"
	inputs: [...string]
	outputs: [...string]
	exitGate: [_, ...string]
	dependsOn?: [...string]
}

#AdapterContract: {
	name: string
	input: string
	output: string
	authority: "none" | "cue"
}

#Plan: {
	units: [...#LearningUnit]
	adapters: [...#AdapterContract]

	// Keep the first contract useful: dependencies point at declared units,
	// and every unit has a concrete exit gate.
	_declared: close({
		for _, u in units {
			"\(u.id)": true
		}
	})
	for _, u in units {
		if u.dependsOn != _|_ {
			for _, d in u.dependsOn {
				_declared: "\(d)": true
			}
		}
	}
}
```

Use this to declare a concrete `plan` value:

```cue
plan: #Plan & {
	units: [
		{id: "cue.schema-basics", layer: "cue", inputs: [], outputs: ["learning/plan.cue"], exitGate: ["cue export ./learning -e plan"]},
		{id: "git.object-model", layer: "git", inputs: ["cue.schema-basics"], outputs: ["object micro-katas"], exitGate: ["one object invariant emits datoms"], dependsOn: ["cue.schema-basics"]},
		{id: "git.index-worktree-head", layer: "git", inputs: ["git.object-model"], outputs: ["state micro-katas"], exitGate: ["one index/worktree/HEAD invariant emits datoms"], dependsOn: ["git.object-model"]},
		{id: "rust.serde-cli", layer: "rust", inputs: ["git.index-worktree-head"], outputs: ["gitfacts JSON CLI"], exitGate: ["cargo test"], dependsOn: ["git.index-worktree-head"]},
		{id: "gitoxide.repo-observe", layer: "gitoxide", inputs: ["rust.serde-cli"], outputs: ["gix-backed datoms"], exitGate: ["normalized gix datoms equal normalized shell datoms"], dependsOn: ["rust.serde-cli"]},
		{id: "semagrams.datom-import", layer: "semagrams", inputs: ["gitoxide.repo-observe"], outputs: ["graph/report facts"], exitGate: ["CUE imports Git datoms"], dependsOn: ["gitoxide.repo-observe"]},
		{id: "semagrams.acceptance-report", layer: "semagrams", inputs: ["semagrams.datom-import"], outputs: ["accept/reject report"], exitGate: ["good candidate accepted and bad candidate rejected"], dependsOn: ["semagrams.datom-import"]},
	]
	adapters: [
		{name: "gitfacts-cli", input: "repo path", output: "gitfacts.datoms.v1", authority: "cue"},
		{name: "gitfacts-gix", input: "repo path", output: "gitfacts.datoms.v1", authority: "cue"},
	]
}
```

**Exit gate:**

```bash
cue vet ./learning
cue export ./learning -e plan
```

This phase should be short. The point is not to master CUE fully; it is to establish the authority pattern.

---

## 2. Phase B — `git-katas-progit`: Git primitives before Git libraries

Use `fatb4f/git-katas-progit` as the **semantic curriculum spine**.

Prioritize these sections in order:

| Order | Git layer                     | Why                                         |
| ----: | ----------------------------- | ------------------------------------------- |
|     1 | repository creation/discovery | needed before any adapter can locate `.git` |
|     2 | worktree/index/HEAD           | core state model                            |
|     3 | objects: blob/tree/commit/tag | needed for datom identity                   |
|     4 | refs/branches/remotes         | needed for graph state                      |
|     5 | log/revwalk/history           | needed before gitoxide traversal            |
|     6 | diff/status                   | needed for patch planning                   |
|     7 | reset/revert/restore          | needed for failure-domain probes            |

The repo’s `index.cue` already has a useful schema shape: `#Chapter`, `#Section`, and `#MicroKata`, where each micro-kata has `commands`, `concepts`, `fixture`, and `verify` checks.  Chapter 2 is already mapped across repository creation, recording changes, viewing history, undoing, remotes, and tagging.

### Required mutation

Add Git-internal micro-katas that produce observable facts:

```cue
{
	id: "02.03.object.commit-parent"
	name: "observe commit parent edge"
	kind: "internals"
	commands: ["git commit", "git cat-file -p HEAD"]
	concepts: ["commit", "parent", "tree", "object-id"]
	fixture: { shape: "linear-two-commit-repo" }
	verify: {
		mode: "command-output"
		checks: [
			"HEAD commit has parent field",
			"parent equals previous commit oid",
		]
	}
}
```

**Exit gate:**

Every kata should eventually emit:

```json
{
  "schema": "gitfacts.datoms.v1",
  "kata": "02.03.object.commit-parent",
  "phase": "fixture",
  "datoms": [
    {
      "e": "commit:<head-oid>",
      "a": "git.commit.parent",
      "v": "commit:<parent-oid>",
      "source": {
        "adapter": "git-cli",
        "command": "git cat-file -p HEAD"
      }
    }
  ]
}
```

At this stage, shell scripts are fine. No Rust yet.

---

## 3. Phase C — Rust only after the fact shape is stable

Learn Rust as the implementation language for **deterministic adapters**, not as a general-purpose detour.

Sequence Rust topics like this:

```text
Rust syntax
  ↓
ownership/borrowing enough to read paths and strings
  ↓
Result/Error handling
  ↓
serde Serialize/Deserialize
  ↓
filesystem walking
  ↓
CLI args
  ↓
golden JSON tests
```

The minimum useful Rust project:

```text
gitfacts/
  Cargo.toml
  src/
    main.rs
    model.rs
    adapter.rs
  tests/
    fixtures/
    golden/
```

Initial contract:

```rust
// conceptually
struct Datom {
    e: String,
    a: String,
    v: serde_json::Value,
    source: EvidenceRef,
}
```

**Exit gate:**

```bash
cargo test
gitfacts observe --repo ./fixtures/linear > out/gitfacts.json
cue vet ./contracts ./out/gitfacts.json
```

Do not integrate gitoxide yet. First write a Rust adapter that shells out to `git` or reads prebuilt fixture files. That isolates Rust learning from gitoxide API complexity.

---

## 4. Phase D — gitoxide/gix: replace shell Git observation with library-backed facts

Important distinction: `gitoxide` is the command-line application crate, while application developers should use the `gix` crate for API access. Avoid scripting against unstable binaries; consume the library from Rust instead. ([Docs.rs][1])

### Adapter order

Implement read-only facts first:

```text
repo discovery
  ↓
HEAD / branch / ref facts
  ↓
object facts: blob/tree/commit/tag
  ↓
commit graph traversal
  ↓
status / index facts
  ↓
diff facts
```

Do **not** start with clone/fetch/push/rebase. Those are operational Git behaviors, not learning-plan primitives.

`gitoxide`/`gix` exposes or plans coverage for reading/writing objects, refs, index, config, commit-graph traversal, status, diff, pathspecs, revspecs, worktrees, reset, merge, and related Git features. ([Docs.rs][1]) For your sequence, only the read-only subset matters first.

**Exit gate:**

For every Git kata:

```text
normalize(shell Git observation) == normalize(gix-backed observation)
```

Equivalence means normalized datom equality: sort datoms deterministically, normalize paths relative to the repository root, and compare `e`, `a`, `v`, `phase`, and `kata`. Exclude unstable evidence fields such as command strings, absolute paths, timestamps, adapter names, and output ordering unless a kata explicitly tests one of those fields.

Example report:

```json
{
  "adapter": "gitfacts-gix",
  "kata": "02.03.object.commit-parent",
  "equivalentToPorcelain": true,
  "datomCount": 7,
  "accepted": true
}
```

---

## 5. Phase E — semagrams integration: datoms into CUE-owned acceptance

The semagrams branch already defines the target control loop:

```text
tool facts
  -> normalized evidence
  -> CUE constraints
  -> graph/model/patch-plan derivation
  -> candidate re-observation
  -> CUE accept/reject
```

That is explicitly described as proven theory in the branch’s slice notes.  The hard invariant is also already right: scripts/tools produce facts, while CUE validates facts, derives graph/model/patch-plan artifacts, and gates acceptance.

Current semagrams/patchplan is TypeScript-oriented: it extracts CST, compiler, LSP, and VCS facts; imports them into CUE; derives graph/model/acceptance outputs; generates a candidate; re-observes the candidate; and accepts/rejects by unification.

Your integration should therefore be:

```text
existing TS patchplan facts
  +
new Git datoms from git-katas/gitfacts
  ↓
unified evidence graph
  ↓
CUE report contract
```

### Minimal datom schema

```cue
package semagrams

#EvidenceRef: {
	adapter: string
	command?: string
	path?: string
}

#Datom: {
	e: string
	a: string
	v: string | int | bool
	source: #EvidenceRef
}

#DatomSet: {
	schema: "gitfacts.datoms.v1"
	kata: string
	phase: "live" | "candidate" | "fixture"
	datoms: [...#Datom]
}
```

### First Git datom families

```text
git.repo.root
git.repo.head
git.repo.branch
git.ref.pointsTo
git.commit.tree
git.commit.parent
git.tree.entry
git.index.entry
git.worktree.status
git.diff.touches
```

Then map these into semagrams graph nodes/edges.

The existing schema already has repo/VCS facts, semantic nodes/edges, patch layers, patch-stack validation, compiler sensor facts, and final reports.    It also already encodes final report acceptance as a conjunction of candidate conditions such as no console calls, logger binding present, compiler/LSP clean, non-empty diff, resolved references, deterministic semantic ordering, and no scope violations.

Your Git datoms should become another evidence stream inside that same acceptance model, not a separate validation framework.

---

## 6. Practical sequencing as gates

| Phase | Learn                                      | Build                      | Exit gate                             |
| ----: | ------------------------------------------ | -------------------------- | ------------------------------------- |
|     A | CUE schemas, unification, `cue vet/export` | `learning/plan.cue`        | plan exports                          |
|     B | Git primitives via Pro Git/katas           | CUE-indexed micro-katas    | each kata has one invariant           |
|     C | Rust basics for adapters                   | `gitfacts` JSON CLI        | golden JSON tests pass                |
|     D | `gix` API                                  | replace shell Git facts    | normalized shell datoms == gix datoms |
|     E | semagrams lowering                         | `DatomSet -> graph/report` | CUE accepts/rejects deterministically |
|     F | stress probes                              | scale, bad cases, replay   | good accepted, bad rejected           |

---

## 7. Weekly implementation order

### Week 1 — Contract spine

```text
learning/
  plan.cue
  adapters.cue
  gates.cue
```

Output:

```bash
cue export ./learning -e plan
```

No Rust.

---

### Week 2 — Git kata fact shape

Add or refine 5–10 micro-katas:

```text
repo-init
stage-file
commit-file
inspect-head
inspect-commit-tree
inspect-parent
branch-ref
status-clean-dirty
diff-touches-path
```

Each gets:

```text
fixture
commands
expected observable invariant
fact output shape
```

---

### Week 3 — Shell-backed `gitfacts`

Before Rust:

```bash
gitfacts-sh observe --repo fixtures/linear
```

Output:

```json
{
  "schema": "gitfacts.datoms.v1",
  "kata": "02.03.object.commit-parent",
  "phase": "fixture",
  "datoms": [
    {
      "e": "commit:<head-oid>",
      "a": "git.commit.parent",
      "v": "commit:<parent-oid>",
      "source": {
        "adapter": "git-cli",
        "command": "git cat-file -p HEAD"
      }
    }
  ]
}
```

CUE validates the JSON and rejects an otherwise valid-looking result with an empty datom set for this kata.

---

### Week 4 — Rust adapter skeleton

Port only the JSON model and CLI.

No gitoxide yet.

```text
read fixture path
emit fixed datoms
serde roundtrip
golden tests
```

---

### Week 5 — `gix` read-only repo facts

Add:

```text
discover repo
read HEAD
read branch/ref
read commit object
read parent/tree edges
```

Do not touch network, clone, fetch, push, merge, or rebase.

---

### Week 6 — gix vs Git equivalence

For each kata:

```text
normalize(git porcelain/plumbing datoms)
  compared with
normalize(gix-backed datoms)
```

CUE report:

```cue
accepted: normalizedDatomsEquivalent && datomsValid && deterministic
```

---

### Week 7 — semagrams import

Add:

```text
patchplan/out/live/git-datoms.json
patchplan/out/candidate/git-datoms.json
```

Then derive:

```text
git datoms -> graph nodes/edges
```

---

### Week 8 — acceptance integration

Extend report acceptance with Git evidence:

```cue
candidate: {
	gitFactsPresent: bool
	gitFactsDeterministic: bool
	gitDiffObserved: bool
}

accepted: existingAcceptance &&
	candidate.gitFactsPresent &&
	candidate.gitFactsDeterministic &&
	candidate.gitDiffObserved
```

---

## 8. The main constraint: avoid premature integration

### Avoid

```text
Rust-first
gitoxide-first
multi-language semagrams
full refactoring engine
agent workflow
network Git operations
mutable Git operations
```

### Prefer

```text
CUE contract
small fixture
one Git primitive
one observable invariant
one adapter
one datom family
one CUE acceptance gate
```

---

## 9. Final dependency rule

Use this rule to decide what to learn next:

```text
Only learn a lower-level implementation tool when a higher-level contract already exists that can judge it.
```

Applied here:

```text
CUE judges the learning plan.
git-katas judge Git understanding.
CUE judges Git fact shape.
Rust implements the adapter.
gix replaces shell observation.
semagrams consumes datoms.
CUE accepts/rejects the integrated result.
```

That gives you a clean control loop instead of five parallel tracks.

[1]: https://docs.rs/gitoxide/latest/gitoxide/ "gitoxide - Docs.rs"
