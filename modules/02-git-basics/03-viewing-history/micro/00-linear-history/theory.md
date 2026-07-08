# Linear History — Git Theory

## Learning target

Learn what a linear history is as a Git graph/state concept before encoding it as lattice or CUE.

A Git repository stores immutable objects. A commit object names one tree object, zero or more parent commits, author and committer metadata, and a message. Branches and tags are refs that point at objects. `HEAD` selects either a branch ref or a detached commit. History commands are projections over this object/ref state.

## Core theory

A linear history is a selected commit path where every commit in the selected scope has at most one selected parent. The repository as a whole is still a DAG. Linearity is a property of a projection from a selected ref, not a property of the object database.

```text
HEAD -> C3 -> C2 -> C1
```

This is linear in the selected scope because each selected commit has zero or one parent in the selected path.

```text
HEAD -> M
       / \
     A2   B2
     |    |
     A1   B1
```

This is not strict linear history at `M` because `M` is a merge commit with two parents.

## What `git log` teaches

`git log` is not the graph authority. It renders reachable commits from a revision expression. Its default view is newest first. It can hide topology depending on flags, formatting, path filters, or simplification modes.

Important distinctions:

- `git log` renders a view.
- `git rev-list` enumerates commit object ids for revision walking.
- `git cat-file -p <commit>` exposes the commit object's parent lines.
- `git merge --ff-only` preserves a linear branch path by moving a ref to an existing descendant.
- `git rebase` creates replacement commits with new object ids, then moves a ref to the new path.

## Required concepts

- object identity: commit ids name immutable objects;
- parent relation: commit objects store parent object ids;
- ref state: branch refs and `HEAD` select graph tips;
- reachability: selected history is the ancestor closure of the selected tip, possibly filtered by the query;
- root or boundary: the oldest commit in the selected scope has no selected parent;
- metadata projection: author, committer, and message are fields on commit objects, not separate facts invented by the report.

## Invariants to learn

- If `HEAD` resolves, it names one selected object id.
- A non-empty selected history has a newest commit.
- In the default selected path, the newest commit is the resolved ref target.
- Strict linearity forbids selected commits with more than one parent.
- The root or boundary commit has no selected parent in scope.
- Moving a ref changes selection state; it does not mutate commit objects.
- Rebase does not edit the old commits. It writes new commits with new ids.
- A fast-forward update preserves linearity because it moves a ref along an existing descendant relation.

## What must be implemented from the theory

An implementation must be able to:

1. resolve the selected ref;
2. enumerate reachable commits in deterministic order;
3. read each commit object's parent ids;
4. prove the selected scope is non-empty;
5. reject merge topology when strict linearity is required;
6. identify newest and oldest selected commits;
7. project newest commit author and subject from the commit object;
8. preserve the difference between object graph state and rendered command output.

## Adapter lenses

- Git CLI: `rev-parse`, `rev-list`, `cat-file`, `log --format`.
- go-git: repository refs, commit object lookup, parent traversal, worktree-independent object reads.
- gitoxide/gix: object database reads, revision walking, commit decoding, ref resolution.

## Anti-models

- Linear history means Git has no DAG.
- A branch name is the history itself.
- `git log` output is the authority rather than a projection.
- Rebase mutates existing commits in place.
- A report may invent facts that were not observed from objects or refs.