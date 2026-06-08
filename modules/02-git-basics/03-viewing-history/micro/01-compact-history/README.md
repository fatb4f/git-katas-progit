# 02.03.01 — 01-compact-history

## Objective

Map short hashes to commit subjects.

## Primary command family

```bash
git log --oneline
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
- `kata.cue` — machine-readable kata contract
