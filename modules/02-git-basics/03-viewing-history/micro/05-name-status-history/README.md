# 02.03.05 — 05-name-status-history

## Objective

Classify A/M/D file transitions.

## Primary command family

```bash
git log --name-only / --name-status
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
