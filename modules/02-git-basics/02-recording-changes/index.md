# 02.02 — Recording Changes Micro-Kata Index

| ID | Micro-kata | Source | Commands | Invariant |
|---:|---|---|---|---|
| 02.02.00 | observe-untracked-file | basic-staging | `git status` | untracked file visible to Git |
| 02.02.01 | stage-new-file | basic-staging | `git add` | file moves into index |
| 02.02.02 | commit-staged-file | basic-commits | `git commit` | index snapshot becomes HEAD commit |
| 02.02.03 | modify-tracked-file | basic-staging | edit + `git status` | tracked file becomes modified |
| 02.02.04 | stage-modification | basic-staging | `git add` | modified content enters index |
| 02.02.05 | ignore-file | ignore | `.gitignore` | generated path excluded from status noise |
| 02.02.06 | remove-tracked-file | git-rm/new | `git rm` | tracked file removal is staged |
