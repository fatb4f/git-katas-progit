# 02.04 — Undoing Things Micro-Kata Index

| ID | Micro-kata | Source | Commands | Invariant |
|---:|---|---|---|---|
| 02.04.00 | amend-last-commit | amend | `git commit --amend` | HEAD commit replaced with new commit |
| 02.04.01 | unstage-file | basic-staging/reset | `git restore --staged` | index reset, worktree preserved |
| 02.04.02 | restore-working-tree-file | new | `git restore` | worktree path restored from index/HEAD |
| 02.04.03 | revert-commit | basic-revert | `git revert` | inverse commit added, history preserved |
| 02.04.04 | reset-soft | reset | `git reset --soft` | ref moves, index/worktree preserved |
| 02.04.05 | reset-mixed | reset | `git reset --mixed` | ref and index move, worktree preserved |
| 02.04.06 | reset-hard | reset | `git reset --hard` | ref, index, and worktree move together |
