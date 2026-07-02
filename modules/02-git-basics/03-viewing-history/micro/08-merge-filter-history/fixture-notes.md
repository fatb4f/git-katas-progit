# Fixture Notes — 08-merge-filter-history

Fixture: `branch-merge`

Shape: normal commits plus one merge commit.

Required properties:

- `git log --merges` returns the merge commit
- `git log --no-merges` excludes the merge commit
- merge parent hashes are known
