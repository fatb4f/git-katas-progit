# Fixture Notes — 04-stat-history

Fixture: `file-evolution`

Shape: several commits touching multiple files.

Required properties:

- one commit clearly changes the largest number of files
- at least one commit has deletions
- `git log --stat` and `git log --shortstat` expose the expected counts
