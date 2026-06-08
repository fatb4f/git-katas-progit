# 02.03 — Viewing the Commit History

This section converts Pro Git's `git log` chapter into executable inspection micro-katas.

## Core Contract

```text
git log
  input: reachable commit graph
  controls: shape, range, filter, topology
  output: ordered commit records
```

## Micro-Kata Track

| ID | Name | Kind | Main commands | Source slice |
|---:|---|---|---|---|
| 02.03.00 | linear-history | inspection | `git log` | basic-commits |
| 02.03.01 | compact-history | inspection | `git log --oneline` | basic-commits |
| 02.03.02 | limit-history | inspection | `git log -n`, `--since`, `--until` | bridge |
| 02.03.03 | patch-history | inspection | `git log -p`, `git show` | basic-commits, amend, revert |
| 02.03.04 | stat-history | inspection | `git log --stat`, `--shortstat` | basic-staging |
| 02.03.05 | name-status-history | inspection | `--name-only`, `--name-status` | basic-staging, ignore, git-rm |
| 02.03.06 | path-limited-history | inspection | `git log -- <path>` | basic-staging, investigation |
| 02.03.07 | graph-history | inspection | `--graph --oneline --decorate --all` | branching, merge |
| 02.03.08 | merge-filter-history | inspection | `--merges`, `--no-merges` | 3-way-merge, merge-conflict |
| 02.03.09 | message-author-date-filter | inspection | `--grep`, `--author`, `--since` | bridge |
| 02.03.10 | pickaxe-history | inspection | `git log -S` | investigation, bisect |
| 02.03.11 | tag-decorated-history | inspection | `--decorate`, `tag..HEAD` | git-tag |
| 02.03.12 | history-query-composition | inspection | composed filters | capstone |

## Fixture Strategy

Use a small number of reusable fixtures:

| Fixture | Shape | Used by |
|---|---|---|
| `linear-5` | five linear commits | 00, 01, 02, 03, 04 |
| `file-evolution` | multiple files changed across commits | 04, 05, 06 |
| `branch-merge` | two branches plus one merge commit | 07, 08 |
| `metadata-varied` | varied authors, dates, messages | 09 |
| `symbol-lifecycle` | symbol introduced, changed, removed | 10 |
| `tagged-release` | tags across release commits | 11, 12 |

## Verification Style

Prefer answer files:

```text
.answers/
├── newest_commit
├── oldest_commit
├── file_touching_commits
├── merge_commit
├── introduced_symbol_commit
└── commits_after_tag
```
