# CUE workflow — Linear History Provenance

This plane operationalizes the theory and lattice model as a reusable Git analysis workflow.

The workflow is not a kata lifecycle controller. It resolves an SCM repository-analysis problem:

1. collect Git facts;
2. refine collector outputs into named fact slots;
3. derive witnesses from those fact slots;
4. validate lattice refinements, checks, and bottom cases;
5. project a report from the validated analysis state.

The fact ids produced by collectors are the ids consumed by evidence, witnesses, validation checks, and report projection. That keeps this plane transferable to real repositories instead of making it a prose summary of a learner exercise.

Adapter-facing fields are explicit: `parameters` declare runtime inputs, collectors declare command specs, parsers, and output bindings, evidence declares fact value shapes, witnesses declare derivations, checks declare predicates, and reports declare render source paths.

`plan.cue` uses `contracts/constructors.cue` to close the workflow obligation and prove that resources, gates, and witnesses referenced by operations are declared.
