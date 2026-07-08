# Linear History — Lattice Projection

Once the theory crosses into lattice form, this module uses the `fatb4f/lattice/meta/kernel.cue` ontology. There is no local module ontology here.

## Kernel vocabulary

The lattice surface is expressed with kernel concepts:

- `Resource`: the maintained theory, lattice, CUE projection, deliverable, and contract surfaces.
- `Operation`: the monotone projection steps between those resources.
- `Gate`: constraints that must hold before a projection is admitted.
- `Witness`: evidence that the projection preserves the intended Git theory.
- `ObligationState`: the complete module state.
- `ClosedObligationState`: the closed state produced by the kernel constructor.

## Projection path

```text
Git theory authority
  -> lattice projection
    -> CUE projection
      -> workflow / adapter / tool deliverables
        -> closed kernel obligation state
```

## Refinement path

```text
unknown selected repository state
  ∧ selected ref resolves
  ∧ selected history is non-empty
  ∧ newest commit is selected ref target
  ∧ each selected commit has zero-or-one selected parent
  ∧ oldest selected commit is the terminal selected boundary
  ∧ required metadata is present
= closed linear-history understanding
```

## Boundary rule

Prose is allowed in `theory.md`. After this boundary, the module is represented by kernel resources, operations, gates, and witnesses. Extra metadata is only admitted when it is one of those kernel concepts or a reusable pattern over those concepts.

## Pattern rule

Patterns from `fatb4f/lattice/patterns` may compress wiring, but they must not introduce a second ontology. A pattern is valid only when it expands to kernel-shaped resources, operations, gates, witnesses, or proofs.