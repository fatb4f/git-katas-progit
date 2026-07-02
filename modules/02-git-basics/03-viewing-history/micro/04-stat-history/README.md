# 02.03.04 — 04-stat-history

## Objective

Identify change volume and touched files.

## Primary command family

```bash
git log --stat
git log --shortstat
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
