# Fixture Notes — 06-path-limited-history

Fixture: `file-evolution`

Shape: `app/config.txt` changed in non-consecutive commits.

Required properties:

- `app/config.txt` exists in the fixture history
- unrelated commits are reachable from `HEAD`
- `git log -- app/config.txt` excludes at least one unrelated commit
