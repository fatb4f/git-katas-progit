# 02.03.10 — 10-pickaxe-history

## Objective

Locate introduction/removal of a symbol.

## Primary command family

```bash
git log -S<string>
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
