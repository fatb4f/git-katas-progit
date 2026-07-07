# CUE lattice theory — Linear History Provenance

This plane defines Pro Git primitives as CUE lattice constraints first, then uses those constraints to shape the linear-history workflow. The workflow schema is local to this directory, so the workflow contract can be copied or vendored without the repository kata and theory schemas.

The CUE lesson is the path from unconstrained repository bytes to closed workflow evidence:

1. express Git object storage with `#GitObject`, `#Blob`, `#Tree`, `#Commit`, and `#AnnotatedTag`;
2. express references with `#Reference` and `#HEAD`;
3. express the three trees with `#ThreeTreesSnapshot` and file-state refinements;
4. express linear history with `#LinearHistorySet` and its per-commit parent constraint;
5. close the workflow by unifying adapter JSON/YAML with `#LinearHistoryFacts`;
6. project reports from validated workflow state instead of copying evidence.

`schema.cue` is the ontology and workflow contract. `plan.cue` explains the monotonic refinement path and names where each primitive appears.

`workflow.cue`, `evidence.cue`, and `report.cue` are the implementation example. The adapter must emit structured facts that unify with the ontology; the fact ids produced by collectors are then consumed by evidence, witnesses, validation checks, and report projection.

The `analysis.concept` and `analysis.lattice` values are external identifiers. They document the projection source, but the workflow does not import or type-check the kata, theory, or lattice CUE packages.
