# Linear History — CUE Lattice Theory

## Learning target

Encode the lattice theory in CUE concepts without reintroducing a module-local ontology. CUE is the constraint language used to express refinement, meet, bottom, closure, and projection.

## Lattice concept to CUE concept

| Lattice theory | CUE expression |
|---|---|
| carrier | a value space constrained by definitions |
| refinement order | unification with additional constraints |
| meet | `A & B` |
| bottom | failed unification / incomplete impossible value |
| top | unconstrained or weakly constrained value |
| sublattice | definition refined by additional constraints |
| monotone projection | derived field or operation that only depends on admitted inputs |
| closure | constructor output that injects ids and proves references |

## Git theory to CUE concepts

The theory should eventually be encoded as constraints like these, either directly in this module or through reusable lattice patterns:

```cue
#ObjectID: string & =~"^[0-9a-f]{40}$"

#Commit: {
	hash:    #ObjectID
	parents: [...#ObjectID]
	author:  string & != ""
	message: string
}

#SelectedHistory: {
	head:    #ObjectID
	commits: [...#Commit] & [_, ...]
	newest: commits[0].hash
	_newestIsHead: newest == head
}

#LinearSelectedHistory: #SelectedHistory & {
	_linearity: [for commit in commits {true & (len(commit.parents) <= 1)}]
}
```

Those definitions are not the module ontology. They are the theory payload that an adapter or pattern can emit into the kernel contract.

## CUE bottom cases

The important CUE lesson is not a report schema. It is the way invalid Git states become bottom:

```cue
// unresolved ref: head never becomes #ObjectID
head: _|_

// empty selected history: conflicts with [_, ...]
commits: []

// nonlinear selected history: conflicts with len(parents) <= 1
parents: [p1, p2]
```

## Kernel encoding

The kernel contract does not need a `#GitTheoryModule` or `#CueLatticeTheory` schema. It needs resources that name what must be learned and implemented, operations that move from learning to implementation, gates that constrain those operations, and witnesses that prove the learned theory has been preserved.

In `contract.cue`, the CUE projection should therefore express:

- learning resources for Git theory and lattice theory;
- implementation resources for CUE constraints, adapter observations, and validation surface;
- operations from theory to CUE constraint implementation;
- gates for linearity, non-empty history, ref resolution, and metadata projection;
- witnesses proving newest, oldest, author, subject, and linearity are derived rather than invented.

## Deliverable boundary

Workflow and adapter deliverables should consume this CUE lattice theory. They should not define a separate fact/witness/check ontology unless that ontology is admitted as a reusable lattice pattern.