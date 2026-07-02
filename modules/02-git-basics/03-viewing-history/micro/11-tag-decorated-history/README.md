# 02.03.11 — 11-tag-decorated-history

## Objective

Read tags as commit refs and release boundaries.

## Primary command family

```bash
git log --decorate
git log v1.0..HEAD
```

## Contract

```text
Given: prepared repository fixture
When: learner queries history
Then: learner extracts the requested invariant
```

## Files

- `task.md` — learner-facing task
- `hints.md` — progressive hints
- `verify.md` — intended verification checks
- `fixture-notes.md` — fixture shape and required properties
- `kata.cue` — machine-readable kata contract
