# 02.06 — Tagging Micro-Kata Index

| ID | Micro-kata | Commands | Invariant |
|---:|---|---|---|
| 02.06.00 | create-lightweight-tag | `git tag v1.0` | tag ref points directly at commit |
| 02.06.01 | create-annotated-tag | `git tag -a` | tag object stores metadata and message |
| 02.06.02 | show-tag | `git show <tag>` | learner can inspect tag target and metadata |
| 02.06.03 | checkout-tag | `git checkout <tag>` | HEAD becomes detached at tag target |
| 02.06.04 | compare-tag-range | `git log v1.0..HEAD` | learner can query commits after release boundary |
