# 02.03.09 — 09-message-author-date-filter

## Objective

Query commits by metadata.

## Primary command family

```bash
git log --grep="release"
git log --author="Ada"
git log --since="2024-01-02" --until="2024-01-04"
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
