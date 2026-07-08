# Linear History — Git Theory

This module starts with Git theory and remains prose until the concept crosses into the lattice boundary.

## Concept

A linear history is a selected path through the commit graph where each commit in scope has at most one parent in that selected path. It is not the whole object database and it is not a claim that Git is non-graph-shaped. Git remains a directed acyclic graph of commit objects; linear history is a constrained projection from a chosen ref, usually `HEAD`.

`git log` is a read-only projection over that graph. In the simplest case, the newest visible commit is the selected ref target, and each displayed commit walks backward through a single parent chain until a root or boundary commit is reached.

## Git primitives

- commit object
- parent pointer
- commit hash
- author metadata
- commit subject/message
- branch or detached `HEAD`
- reachable history from the selected ref

## Observable invariants

- The selected ref resolves to a commit object.
- The selected history is non-empty.
- The newest selected commit is the resolved ref target.
- Each selected commit has zero or one selected parent when strict linearity is required.
- The oldest selected commit is the terminal root or boundary commit in the selected scope.
- Commit identity is stable; moving a ref changes the selected path, not the commit object.
- Rebase copies commits into a new path; it does not mutate old commit objects in place.

## Bottom cases

- unresolved ref
- empty selected history
- merge topology where strict linearity is required
- missing required metadata
- evidence that diverges from observed commit graph state

## Anti-models

- Linear history means Git has no DAG.
- A branch name is the history itself.
- Rebase mutates existing commits in place.
- A rendered log is the authoritative graph instead of a projection over graph state.

## Downstream use

A closed linear-history read is a precondition for safe history-sensitive workflows: amend, revert, reset, rebase, cherry-pick, release audit, provenance reporting, and agent-driven repository edits.