# Fixture Notes — 12-history-query-composition

Fixture: `tagged-release`

Shape: branch graph with tags, authors, messages, and paths.

Required properties:

- `v1.0..HEAD` selects a non-empty range
- at least one selected commit matches author `Ada`
- at least one selected commit matches message text `release`
- `app/config.txt` is touched by the expected composed-query result
