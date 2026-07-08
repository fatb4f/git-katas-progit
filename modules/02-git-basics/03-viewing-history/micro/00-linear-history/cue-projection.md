# Linear History — CUE Projection

`contract.cue` is the machine surface for this module. It imports `fatb4f/lattice/meta` and expresses the module as one kernel-shaped obligation state.

## Projection rule

Do not encode a local module schema such as `#GitTheoryModule`, `#LinearHistoryWorkflow`, or `#CueLatticeTheory` here. The kernel is the ontology.

The CUE projection should use:

- `lat.#ObligationState` for the module surface;
- `lat.#MakeClosedObligationState` to close map-keyed ids;
- `lat.#NoWideningProof` when a target projection must prove it did not widen beyond authority;
- `Resource`, `Operation`, `Gate`, and `Witness` roles through the kernel fields, not separate local metadata records.

## Maintained resources versus generated resources

The five files in this folder are maintained resources, so operations use `writes` for them.

Use `creates` only for generated outputs. The meta kernel requires created resources to carry the generated-output role, so hand-maintained theory or projection files must not be declared as created resources.

## CUE tool surface

The minimal validation surface is:

```bash
cue export ./modules/02-git-basics/03-viewing-history/micro/00-linear-history -e closedLinearHistory
```

Optional proof export:

```bash
cue export ./modules/02-git-basics/03-viewing-history/micro/00-linear-history -e linearHistorySelfNoWidening
```

## Adapter boundary

Git CLI, go-git, or gitoxide/gix adapters may observe the repository, but their outputs must enter this module as evidence for kernel witnesses or gates. Adapter-specific payload shapes belong behind an adapter boundary, not in a repeated module ontology.