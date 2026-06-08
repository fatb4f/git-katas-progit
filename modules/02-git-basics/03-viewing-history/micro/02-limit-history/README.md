# 02.03.02 — 02-limit-history

## Objective

Return commits inside count/date slices.

## Primary command family

```bash
git log -n / --since / --until
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
