# Git Katas Pro Git Refactor

This project reshapes existing `git-katas` material around the **Pro Git** book progression while introducing **micro-katas**: small, testable learning units focused on one Git primitive and one observable invariant.

## Control Model

```text
Pro Git chapter/section
  -> curriculum index
    -> micro-kata contracts
      -> fixture setup
        -> learner task
          -> verification gate
```

## Project Roles

| Layer | Responsibility |
|---|---|
| Pro Git | Conceptual spine and ordering |
| Existing git-katas | Source exercise material |
| Micro-katas | Small executable learning units |
| CUE indexes | Curriculum metadata, dependencies, contracts |
| Agent instructions | Rewrite rules for converting old kata material |
| Expanded material | Human-readable teaching notes and design rationale |

## Initial Scope

This starter project includes:

- top-level curriculum index
- Chapter 2: Git Basics
- concise matrix for Chapter 2
- agent instructions for refactoring existing katas
- expanded material for Chapter 2
- detailed module index for `02-git-basics/03-viewing-history`

## Micro-Kata Rule

```text
one micro-kata = one Git primitive + one observable invariant
```

Examples:

| Broad kata | Micro-kata split |
|---|---|
| Learn committing | observe status, stage file, commit file, inspect clean tree |
| Learn git log | linear log, oneline log, patch log, path log, graph log |
| Learn undoing | amend, unstage, restore, revert, reset-soft, reset-mixed, reset-hard |

