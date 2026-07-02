# Chapter 2 — Git Basics

Chapter 2 becomes the first high-yield refactor target because it establishes the core state machine:

```text
working tree -> index -> commit -> history -> refs/remotes/tags
```

## Sections

| ID | Section | Role |
|---:|---|---|
| 02.01 | Getting a Git Repository | Create or acquire repository state |
| 02.02 | Recording Changes | Move changes from worktree to index to commit |
| 02.03 | Viewing History | Query commits and graph topology |
| 02.04 | Undoing Things | Move or invert state safely |
| 02.05 | Remotes | Exchange refs and objects with another repository |
| 02.06 | Tagging | Attach stable names to commits |

## Three-Layer Refactor

This module combines three sources of authority:

| Layer | Owns | In this module |
|---|---|---|
| Pro Git | chapter order, concepts, vocabulary | section IDs and conceptual progression |
| git-katas | source exercises, repository situations, learner friction | upstream mappings and reusable fixture shapes |
| CUE | machine-readable learning contract | micro-kata metadata, task outputs, verification checks |

Markdown files explain the learning material. CUE files are the contract source for exact metadata, fixture names, expected outputs, and verifier checks.

## Refactor Principle

Existing git-katas often bundle mutation and inspection in the same exercise. This refactor separates them:

| Kata kind | Learner does | Verification checks |
|---|---|---|
| mutation | changes repository state | state invariants |
| inspection | extracts facts from repository state | answers or command output |
| recovery | locates/restores hidden state | mixed state + answer |
| internals | maps porcelain to objects/refs | object database invariants |

## Chapter Dependency Graph

```text
02.01 repository acquisition
  -> 02.02 recording changes
    -> 02.03 viewing history
      -> 02.04 undoing things
        -> 02.05 remotes
          -> 02.06 tagging
```
