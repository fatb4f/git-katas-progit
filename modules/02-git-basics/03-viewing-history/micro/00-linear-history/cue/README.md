# CUE workflow — Linear History Provenance

This plane operationalizes the theory and lattice model as a reusable Git analysis workflow.

The workflow is not a kata lifecycle controller. It resolves an SCM repository-analysis problem:

1. collect Git facts;
2. shape facts into evidence;
3. validate required witnesses and checks;
4. project a report usable by humans, agents, and later SCM preflight tools.

`plan.cue` uses `contracts/constructors.cue` to close the workflow obligation and prove that resources, gates, and witnesses referenced by operations are declared.
