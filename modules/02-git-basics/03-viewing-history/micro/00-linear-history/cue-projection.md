# Linear History — CUE Kernel Tooling Theory

## Learning target

Learn how an idiomatic CUE kernel provides the building blocks for trustworthy tooling with evidence.

The point is not: Git CLI adapter -> logic core -> CUE bridge -> metadata contract.

The point is:

```text
Git theory
  -> CUE lattice constraints
    -> kernel-shaped evidence tooling
      -> optional cue cmd runner
```

The adapter observes Git. The CUE kernel gives the trustworthy shape for what the tool is allowed to claim, what evidence it must provide, what checks must hold, and what generated projections may be admitted.

## Lattice concept to CUE concept

| Lattice theory | CUE expression |
|---|---|
| carrier | constrained value space |
| refinement order | unification with additional constraints |
| meet | `A & B` |
| bottom | failed unification |
| top | weakly constrained value |
| sublattice | definition refined by additional constraints |
| monotone projection | derived value that depends only on admitted inputs |
| closure | kernel constructor output with references resolved |
| evidence | declared witness resource consumed by an operation |
| trust boundary | no-widening proof between authority and target |

## Git theory to CUE constraints

The Git theory payload can be represented with reusable constraints:

```cue
#ObjectID: string & =~"^[0-9a-f]{40}$"

#Author: {
	name:  string & != ""
	email: string & != ""
}

#Commit: {
	hash:    #ObjectID
	parents: [...#ObjectID]
	author:  #Author
	subject: string
}

#SelectedHistory: {
	ref:     string
	head:    #ObjectID
	commits: [...#Commit] & [_, ...]

	newest: commits[0].hash
	_newestIsHead: newest == head
}

#LinearSelectedHistory: #SelectedHistory & {
	_linearity: [for commit in commits {true & (len(commit.parents) <= 1)}]
}
```

These constraints are not a separate module ontology. They are the domain payload the tool must validate before it can claim evidence.

## Kernel tooling model

The kernel supplies the reusable tooling discipline:

```text
resources/artifacts
  named authority, input, evidence, mutation target, or generated output surfaces

operations/actions
  inspect, validate, generate, collect evidence, report, or adapt surfaces

gates/checks
  predicates that must hold before a claim is admitted

witnesses/evidence
  declared proof material required by operations

closed state
  map-keyed declarations with ids injected and references proven

no-widening proof
  target projection cannot introduce undeclared surfaces or references
```

That is the core design. Git adapter output becomes trustworthy only after it is represented as evidence and validated against CUE lattice constraints.

## Bottom cases as CUE theory

Invalid Git observations should fail as constraints, not as prose-only report warnings:

```cue
// unresolved ref: head never becomes #ObjectID
head: _|_

// empty selected history: conflicts with [_, ...]
commits: []

// nonlinear selected history: conflicts with len(parents) <= 1
parents: [p1, p2]
```

## cue cmd boundary

`cue cmd` may run the workflow, but it is not the semantic center.

Use it as:

```text
cue cmd observe
  -> call adapter
  -> capture JSON
  -> unify with CUE constraints
  -> emit evidence or bottom
```

Do not use it as:

```text
cue cmd owns Git theory
cue cmd owns adapter semantics
cue cmd replaces the kernel evidence model
```

The kernel and constraints must remain useful without the runner: from tests, `just`, CI, Go adapters, Rust adapters, or MCP/tool wrappers.