# Linear History — Lattice Theory

## Learning target

Express the Git theory as an information lattice: start from unknown repository state, refine by observations, and bottom out when observations contradict the required linear-history model.

## Carrier

The carrier is the set of partial observations about a selected Git history:

```text
selected ref
resolved object id
reachable commit set
commit parent relation
commit metadata
selected root or boundary
linearity witness
```

Each observation is partial information. The lattice order is refinement: `a <= b` means `b` contains at least the information in `a` and may add constraints.

```text
unknown
  <= ref selected
  <= ref resolves to object id
  <= reachable commits observed
  <= parent relation observed
  <= parent relation constrained to zero-or-one selected parent
  <= boundary and metadata witnesses derived
  <= closed linear-history understanding
```

## Top, bottom, meet

`top` is unconstrained selected repository state: no ref, no object id, no commit set, no parent relation.

`bottom` is contradiction: an unresolved ref, an empty selected history where non-empty is required, a merge commit where strict linearity is required, missing metadata where provenance is required, or a derived witness that disagrees with observed graph state.

The main operation is meet: conjoin another observation or constraint with the current state. In CUE terms this becomes unification. A state survives when the observations are compatible. It bottoms when they cannot unify.

## Linear-history sublattice

Linear history is a constrained subset of commit-graph observations.

A general selected history admits commits with any finite parent count:

```text
commit.parents: [...object-id]
```

A strict linear-history observation refines that to:

```text
for selected commit c:
  len(c.parents_in_selected_scope) <= 1
```

The linear-history sublattice keeps only states that satisfy the parent-cardinality constraint. Merge commits are valid Git theory, but they are outside this strict linear-history sublattice.

## Monotone projections

The useful projections are monotone: they do not invent facts and they do not remove required constraints.

| Projection | Input | Output |
|---|---|---|
| ref resolution | selected ref | object id |
| revision walk | object id + object database | selected commit sequence |
| parent read | commit sequence | parent relation |
| linearity check | parent relation | linearity witness or bottom |
| boundary projection | linear commit sequence | newest and oldest selected commits |
| metadata projection | newest commit object | author and subject witnesses |

## Closure condition

The closed state exists only when these witnesses are derivable from observed graph state:

- selected ref resolves;
- selected history is non-empty;
- newest selected commit equals the selected ref target;
- every selected commit has zero or one selected parent;
- oldest selected commit is the terminal selected boundary;
- newest author and subject are projected from the newest commit object.

## Bottom cases as theory

- `unresolved-ref`: ref observation cannot refine into an object id.
- `empty-history`: ref resolution did not produce a non-empty commit scope.
- `nonlinear-history`: selected parent relation contains a merge topology.
- `metadata-missing`: required commit metadata cannot be projected.
- `witness-divergence`: derived witness disagrees with object/ref observations.

## Kernel crossing

After this point, do not encode a custom theory schema. The lattice expression crosses into the `fatb4f/lattice/meta` kernel as resources to learn, operations to implement, gates to pass, and witnesses to prove.