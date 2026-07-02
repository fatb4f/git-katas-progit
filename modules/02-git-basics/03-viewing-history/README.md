# 02.03 — Viewing the Commit History

This section converts Pro Git's `git log` chapter into inspection micro-katas backed by reusable git-katas-style fixtures and CUE contracts.

## Core Contract

```text
git log
  input: reachable commit graph
  controls: shape, range, filter, topology
  output: ordered commit records
```

## Micro-Kata Track

| ID | Name | Main commands | Source slice |
|---:|---|---|---|
| 02.03.00 | linear-history | `git log` | basic-commits |
| 02.03.01 | compact-history | `git log --oneline`, `git log --oneline -3` | basic-commits |
| 02.03.02 | limit-history | `git log -2`, `git log --since="2024-01-03"` | bridge |
| 02.03.03 | patch-history | `git log -p`, `git show` | basic-commits, amend, revert |
| 02.03.04 | stat-history | `git log --stat`, `git log --shortstat` | basic-staging |
| 02.03.05 | name-status-history | `git log --name-only`, `git log --name-status` | basic-staging, ignore, git-rm |
| 02.03.06 | path-limited-history | `git log -- app/config.txt` | basic-staging, investigation |
| 02.03.07 | graph-history | `git log --graph --oneline --decorate --all` | branching, merge |
| 02.03.08 | merge-filter-history | `git log --merges`, `git log --no-merges` | 3-way-merge, merge-conflict |
| 02.03.09 | message-author-date-filter | `git log --grep="release"`, `git log --author="Ada"` | bridge |
| 02.03.10 | pickaxe-history | `git log -SfeatureFlag` | investigation, bisect |
| 02.03.11 | tag-decorated-history | `git log --decorate`, `git log v1.0..HEAD` | git-tag |
| 02.03.12 | history-query-composition | `git log v1.0..HEAD --graph --oneline --author="Ada" --grep="release" -- app/config.txt` | capstone |

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

Prefer answer files. The exact output paths live in `kata.cue`; examples include:

```text
.answers/
├── newest_commit
├── oldest_commit
├── file_touching_commits
├── merge_commit
├── introduced_symbol_commit
└── commits_after_tag
```
