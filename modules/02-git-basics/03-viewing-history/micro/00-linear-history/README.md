# 02.03.00 — Linear History

This directory is a vertical SCM-analysis slice. It keeps the Pro Git kata location, but separates the learning task from the theory, lattice expression, and CUE workflow that can resolve the same repository-analysis problem outside the kata.

## Plane layout

| Plane | Path | Purpose |
|---|---|---|
| Theory | `theory/` | SCM and Git theory for linear history provenance. |
| Lattice | `lattice/` | Lattice expression of the analysis as refinements, witnesses, and bottom cases. |
| Micro | `micro/` | Learner-facing micro-kata task and answer schema. |
| CUE | `cue/` | Constructor-backed workflow plan, evidence shape, and report projection. |

## Analysis question

Given a repository fixture and `HEAD`, identify the newest and oldest reachable commits, then extract the newest commit author and subject.

## Tooling intent

The kata trains `scm.history.linear-provenance`, but the CUE workflow is not a kata controller. It is a reusable Git analysis workflow that collects repository facts, shapes evidence, validates witnesses, and reports whether the provenance read is sufficient for downstream SCM work.

## Downstream SCM use

A closed linear-history provenance read is a safe precondition for later mutation workflows such as amend, revert, reset, rebase, cherry-pick, release audit, and agent-driven repository edits.
