# Linear History — Deliverables

## Learning-to-implementation target

The deliverables are the implementation consequences of the theory and lattice model. They should answer: what must a workflow, adapter, or CUE tool implement so the linear-history theory is usable?

## Workflow deliverable

A linear-history workflow must:

1. select a ref, defaulting to `HEAD`;
2. resolve it to an object id;
3. enumerate the selected reachable commits;
4. read parent ids from commit objects;
5. reject merge topology when strict linear history is required;
6. derive newest and oldest selected commits;
7. derive newest author and subject from the newest commit;
8. report only facts that trace to observed object/ref state.

This workflow is read-only. It prepares history-sensitive mutation, but it does not mutate refs, commits, index, or worktree state.

## Git CLI adapter deliverable

Minimum command surface:

```bash
git rev-parse HEAD
git rev-list --parents HEAD
git cat-file -p <commit>
git log -1 --format=%H%x00%an%x00%ae%x00%s HEAD
```

The adapter must normalize command output into the theory payload:

```text
head object id
ordered selected commits
parent relation
newest commit metadata
```

## go-git adapter deliverable

The go-git lens should implement:

- repository open;
- HEAD resolution;
- commit object lookup;
- parent traversal;
- metadata projection;
- error states for unresolved refs, empty history, merge topology, and missing metadata.

The implementation target is not a full porcelain replacement. It is an object/ref observation adapter for the linear-history contract.

## gitoxide/gix adapter deliverable

The gitoxide/gix lens should implement the same observation contract through Rust APIs:

- repository discovery/open;
- ref resolution;
- object database commit decode;
- revision walk or explicit parent traversal;
- metadata projection;
- typed errors that map to bottom cases.

## CUE tool deliverable

The CUE tool surface must expose:

```bash
cue export ./modules/02-git-basics/03-viewing-history/micro/00-linear-history -e closedLinearHistory
```

Future validation can add fixture payloads that intentionally bottom:

- unresolved ref;
- empty history;
- merge commit in strict linear scope;
- missing newest metadata;
- newest witness diverges from selected ref.

## Excluded

- learner answer files;
- fixture-first kata ceremony;
- report-only facts;
- local schema hierarchy that duplicates `fatb4f/lattice/meta`;
- adapter payloads that cannot be mapped to resources, operations, gates, or witnesses.