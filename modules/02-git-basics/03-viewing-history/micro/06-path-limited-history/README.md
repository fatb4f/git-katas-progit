# 02.03.06 — 06-path-limited-history

## Objective

Trace one file and exclude unrelated commits.

## Primary command family

```bash
git log -- app/config.txt
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
