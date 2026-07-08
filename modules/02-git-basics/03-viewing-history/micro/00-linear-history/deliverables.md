# Linear History — Kernel Tooling Deliverables

## Learning-to-implementation target

The deliverables are not just adapter commands. They are the implementation consequences of the theory, lattice model, and idiomatic CUE kernel.

The target is trustworthy CUE tooling with evidence:

```text
adapter observes Git
  -> CUE constraints classify the observation
    -> kernel obligation state records admitted resources, operations, gates, and witnesses
      -> reports or generated outputs are admitted only through no-widening proof
```

## Git CLI adapter deliverable

The Git CLI adapter is a read-only observer. It does not own the theory, the lattice, or the evidence contract.

Minimum command surface:

```bash
git rev-parse HEAD
git rev-list --parents HEAD
git cat-file -p <commit>
git log -1 --format=%H%x00%an%x00%ae%x00%s HEAD
```

Theory behind the commands:

| Command | Theory role |
|---|---|
| `git rev-parse HEAD` | resolve selected ref into object identity |
| `git rev-list --parents HEAD` | enumerate selected reachable commits and parent relation |
| `git cat-file -p <commit>` | inspect commit object authority directly |
| `git log -1 --format=... HEAD` | project newest commit metadata from selected history |

The adapter should emit observations that can become evidence:

```text
head object id
ordered selected commits
parent relation
newest commit metadata
adapter command provenance
exit status / error class
```

## CUE constraint deliverable

The CUE layer receives the adapter observation and classifies it:

- ref resolves or bottoms;
- selected history is non-empty or bottoms;
- newest commit equals selected ref target or bottoms;
- parent relation is strict-linear or bottoms;
- newest metadata is present or bottoms;
- derived witnesses are computed from observed state, not invented by a report.

## Kernel evidence deliverable

The kernel layer supplies the trustworthy tooling surface:

- resources/artifacts declare authority, input, evidence, and generated outputs;
- operations/actions declare allowed reads, writes, creates, checks, and evidence requirements;
- gates/checks encode predicates that must hold;
- witnesses/evidence declare what proof material must exist;
- closed-state constructors inject ids and prove references;
- no-widening proofs prevent generated reports from adding unadmitted surfaces.

This is the important deliverable: the Git adapter is merely one evidence collector for a kernel-shaped CUE tool.

## cue cmd runner deliverable

`cue cmd` is optional orchestration. It can run the adapter and feed the result into CUE validation, but the kernel and constraints remain the semantic authority.

Good runner shape:

```text
cue cmd observe-linear-history
  -> exec Git CLI adapter
  -> capture JSON observation
  -> unify observation with CUE constraints
  -> export closed evidence state or bottom
```

Bad runner shape:

```text
cue cmd contains the Git theory
cue cmd owns the adapter semantics
cue cmd replaces evidence declarations
```

## go-git and gitoxide/gix deliverables

Go and Rust adapters should satisfy the same evidence contract as the Git CLI adapter:

- resolve selected ref;
- enumerate selected commits;
- read parent ids;
- project newest author and subject;
- classify unresolved ref, empty history, nonlinear history, and missing metadata;
- emit data that unifies with the CUE constraints.

The implementation target is adapter interchangeability under one kernel evidence model.

## Excluded

- learner answer files;
- fixture-first kata ceremony;
- report-only facts;
- adapter-specific ontology;
- local schema hierarchy that duplicates `fatb4f/lattice/meta`;
- `cue cmd` as the semantic core.