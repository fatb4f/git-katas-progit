# Linear History — Deliverables

Deliverables stem from the kernel obligation state in `contract.cue`. They are not a separate metadata plane.

## Workflow deliverables

- Inspect the selected ref and reachable history before history-sensitive mutation.
- Confirm the selected history is linear when strict linearity is a workflow precondition.
- Preserve the distinction between immutable commit objects and mutable refs.
- Treat rendered history as a projection, not the authority.

## Adapter deliverables

Adapters may be implemented over:

- Git CLI commands such as `git rev-parse`, `git log`, `git cat-file`, and `git rev-list`;
- go-git traversal and object APIs;
- gitoxide/gix traversal and object APIs.

Adapter outputs are admissible only when they support a kernel witness or gate. The adapter does not own the ontology.

## CUE tool deliverables

- Export the closed module state.
- Validate that all operation references point to declared resources, gates, and witnesses.
- Prove that derived projections do not widen beyond the admitted kernel surface when a target projection is introduced.

## Contract trace

| Deliverable | Kernel concept |
|---|---|
| theory note | `Resource` |
| lattice projection | `Operation` writing `Resource` |
| CUE projection | `Operation` writing `Resource` |
| workflow/adapters/tools | `Operation` writing `Resource` |
| semantic preservation | `Gate` |
| linear-history invariants | `Witness` |
| closed validation | `ClosedObligationState` |

## Excluded

- learner-task boilerplate;
- answer-file ceremony;
- fixture-first kata controller shape;
- repeated local workflow metadata;
- local schema hierarchy that duplicates the lattice meta kernel.