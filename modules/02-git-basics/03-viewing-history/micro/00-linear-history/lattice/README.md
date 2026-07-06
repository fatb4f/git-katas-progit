# Lattice — Linear History Provenance

The lattice plane expresses the Git analysis as fact refinement, not as a kata lifecycle controller.

```text
unknown repository state
  ∧ repository exists
  ∧ HEAD resolves
  ∧ reachable commit set is observed
  ∧ parent map is observed
  ∧ selected history is linear
  ∧ commit metadata is observed
  ∧ boundary commits are identified
  ∧ witnesses are extracted
= closed linear-history provenance evidence
```

## Witnesses

- `newest-commit`
- `oldest-commit`
- `newest-author`
- `newest-subject`
- `linearity`

## Bottom cases

- unresolved `HEAD`;
- no reachable commits in the selected scope;
- nonlinear history when linearity is required;
- unavailable author or subject metadata;
- answer evidence does not match observed facts.

## Constructor use

The constructor kernel is used in `../cue/plan.cue` to close the workflow obligation and prove operation references to resources, gates, and witnesses are declared.
