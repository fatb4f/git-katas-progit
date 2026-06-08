# 02.03.08 — 08-merge-filter-history

## Objective

Separate merge commits from ordinary commits.

## Primary command family

```bash
git log --merges / --no-merges
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
