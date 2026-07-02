# 02.03.02 — 02-limit-history

## Objective

Return commits inside count/date slices.

## Primary command family

```bash
git log -2
git log --since="2024-01-03"
git log --until="2024-01-03"
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
