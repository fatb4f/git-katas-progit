# 02.03.03 — 03-patch-history

## Objective

Find which commit added or removed a line.

## Primary command family

```bash
git log -p / git show
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
