# 02.03 — Viewing the Commit History

This section converts Pro Git's `git log` chapter into native Git+CUE micro-katas backed by reusable git-katas-style fixtures and executable CUE lattice contracts.

## Core Contract

```text
git log
  input: reachable commit graph
  controls: shape, range, filter, topology
  output: ordered commit records
```

## Git+CUE Control Plane

Each micro-kata is both a Git workflow and a CUE lattice problem:

```text
Git:
  inspect repository history
  record answer evidence

CUE:
  declare resources, operations, gates, and witnesses
  close the obligation state with #MakeClosedObligationState
  reject dangling workflow references during evaluation
```

The executable kernel is the repo-local `contracts/constructors.cue`. It is expected to remain identical to `/home/_404/src/lattice/meta/kernel.cue`; use `diff -q /home/_404/src/lattice/meta/kernel.cue contracts/constructors.cue` as the provenance check.

The kata loop is:

```text
inspect -> witness -> cue eval -> promote
```

`git` fields define the real repository workflow. `cue.obligation` defines the lattice state for that workflow. `cue.closed` is derived by the constructor and proves that all operation references point to declared resources, gates, and witnesses.

## Micro-Kata Track

| ID | Name | Main commands | Lattice problem |
|---:|---|---|---|
| 02.03.00 | linear-history | `git log` | provenance witnesses |
| 02.03.01 | compact-history | `git log --oneline`, `git log --oneline -3` | bounded projection |
| 02.03.02 | limit-history | `git log -2`, `git log --since="2024-01-03"` | count/date constraints |
| 02.03.03 | patch-history | `git log -p`, `git show` | patch-derived witnesses |
| 02.03.04 | stat-history | `git log --stat`, `git log --shortstat` | summary projection |
| 02.03.05 | name-status-history | `git log --name-only`, `git log --name-status` | path-status projection |
| 02.03.06 | path-limited-history | `git log -- app/config.txt` | pathscope gate |
| 02.03.07 | graph-history | `git log --graph --oneline --decorate --all` | topology witnesses |
| 02.03.08 | merge-filter-history | `git log --merges`, `git log --no-merges` | merge classification |
| 02.03.09 | message-author-date-filter | `git log --grep="release"`, `git log --author="Ada"` | metadata constraints |
| 02.03.10 | pickaxe-history | `git log -SfeatureFlag` | semantic symbol witnesses |
| 02.03.11 | tag-decorated-history | `git log --decorate`, `git log v1.0..HEAD` | ref boundary gate |
| 02.03.12 | history-query-composition | `git log v1.0..HEAD --graph --oneline --author="Ada" --grep="release" -- app/config.txt` | composed gates |

## Fixture Strategy

Use a small number of reusable fixtures:

| Fixture | Shape | Used by |
|---|---|---|
| `linear-5` | five linear commits, optionally with controlled dates and small text changes | 00, 01, 02, 03 |
| `file-evolution` | multiple files changed across commits | 04, 05, 06 |
| `branch-merge` | two branches plus one merge commit | 07, 08 |
| `metadata-varied` | varied authors, dates, messages | 09 |
| `symbol-lifecycle` | symbol introduced, changed, removed | 10 |
| `tagged-release` | tags across release commits | 11, 12 |

## Verification Style

Each kata verifies answer evidence and CUE closure. The exact output paths and witness names live in `kata.cue`; examples include:

```text
.answers/
├── newest_commit
├── oldest_commit
├── file_touching_commits
├── merge_commit
├── introduced_symbol_commit
└── commits_after_tag
```
