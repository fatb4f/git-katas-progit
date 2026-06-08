# 02.03.07 — 07-graph-history

## Objective

Read branch tips, HEAD, and merge topology.

## Primary command family

```bash
git log --graph --oneline --decorate --all
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
