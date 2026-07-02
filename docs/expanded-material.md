# Expanded Material — Pro Git Progression + Micro-Kata Refactor

## 1. Why Refactor Around Pro Git?

The existing kata model is effective for command practice, but its ordering is not a full curriculum spine. Pro Git supplies a stable conceptual sequence:

```text
repository acquisition
  -> recording changes
    -> reading history
      -> undoing
        -> remotes
          -> tags
            -> branching
              -> tools
                -> internals
```

The refactor keeps the strengths of both sources:

| Source | Strength |
|---|---|
| Pro Git | conceptual ordering and vocabulary |
| git-katas | hands-on practice and repository fixtures |
| CUE | machine-readable contracts and validation gates |
| micro-katas | small validation-friendly units |

Use the layers this way:

```text
Pro Git decides where a concept belongs.
git-katas contributes the practical repository situation.
CUE defines the exact task, fixture, outputs, and checks.
Markdown explains the learning intent.
```

If Markdown and CUE disagree, update CUE first and then mirror the learner-facing explanation.

## 2. Why Micro-Katas?

Large katas often mix several hidden skills. For example, a basic commit kata may require:

- observing untracked files
- staging files
- committing files
- reading commit output
- using `git log`
- interpreting a clean worktree

Those are separate primitives. If they are bundled, failure is ambiguous.

Micro-katas reduce ambiguity:

```text
failure in stage-new-file means index transition failed
failure in linear-history means history query failed
failure in reset-mixed means ref/index/worktree model failed
```

## 3. Curriculum Control Theory

Each micro-kata should expose a clear loop:

```text
intent -> command -> Git state transition -> observation -> verification
```

Example:

```text
intent: record file content
command: git add + git commit
transition: worktree content becomes reachable from commit object
observation: git status clean, git log shows new commit
verification: HEAD commit contains expected file content
```

## 4. Mutation vs Inspection

Separate mutation katas from inspection katas.

Mutation katas ask:

```text
Can you move Git state correctly?
```

Inspection katas ask:

```text
Can you query existing Git state correctly?
```

This matters because advanced Git skill is mostly inspection-gated. You cannot safely rebase, reset, recover, or debug without reading refs, history, patches, and graph shape.

## 5. Chapter 2 as Foundation

Chapter 2 should produce a learner who can reason about:

```text
working tree
index
commit
history
remote refs
tags
```

The most important bridge is between `Recording Changes` and `Viewing History`:

```text
I changed state
  -> I can inspect the state I created
```

## 6. Expanded Chapter 2 Section Notes

### 02.01 Getting a Repository

Main invariant:

```text
A Git repository is a directory with Git metadata and an object/ref database.
```

Micro-katas:

- initialize empty repository
- clone existing repository
- locate `.git`
- distinguish worktree from Git metadata

### 02.02 Recording Changes

Main invariant:

```text
Git records snapshots by moving content from working tree to index to commit.
```

Micro-katas:

- observe untracked file
- stage new file
- inspect staged diff
- commit staged file
- modify tracked file
- ignore generated file
- remove tracked file

### 02.03 Viewing History

Main invariant:

```text
`git log` is a query interface over reachable commits.
```

Micro-katas:

- read full commit metadata
- compact the log
- limit log range
- inspect patches
- inspect stats
- inspect path-specific history
- inspect branch graph
- filter merges
- filter by author/message/date
- search history with pickaxe
- read tags in history
- compose history queries

### 02.04 Undoing Things

Main invariant:

```text
Undo operations move refs, index entries, worktree files, or create inverse commits.
```

Micro-katas:

- amend commit
- unstage file
- restore worktree file
- revert commit
- reset soft
- reset mixed
- reset hard

### 02.05 Remotes

Main invariant:

```text
Remote operations exchange objects and refs between repositories.
```

Micro-katas:

- add remote
- fetch remote
- inspect remote-tracking branch
- push branch
- pull branch

### 02.06 Tagging

Main invariant:

```text
A tag is a stable ref to a commit or tag object.
```

Micro-katas:

- create lightweight tag
- create annotated tag
- show tag
- compare tag range
- checkout tag safely

## 7. Verification Design

### State verification

Use for mutation katas.

Examples:

- file is staged
- HEAD advanced
- branch exists
- worktree is clean
- tag exists

### Answer verification

Use for inspection katas.

Examples:

- learner provides newest commit hash
- learner identifies merge commit
- learner identifies commit that introduced a symbol

### Command-output verification

Use when the task is about output shape.

Examples:

- `git log --oneline` has one commit per line
- graph output includes branch decoration

### Mixed verification

Use for recovery/debugging.

Examples:

- learner identifies lost commit and restores branch pointer

## 8. First Implementation Target

The recommended first implementation slice is:

```text
02-git-basics/02-recording-changes
02-git-basics/03-viewing-history
02-git-basics/04-undoing-things
```

This gives a complete loop:

```text
create state -> inspect state -> safely modify/recover state
```

## 9. Anti-Patterns

Avoid:

- one huge kata per Pro Git section
- passive reading tasks
- verification based only on command history
- requiring exact command spelling when state invariant is what matters
- mixing advanced internals into beginner sections without labeling as preview

Prefer:

- small repository fixtures
- stable answer files
- invariant-based checks
- explicit source mapping
- predictable IDs
