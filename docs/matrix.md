Source: 

## Governing contract matrix

| Axis             | Contract                                                                        |
| ---------------- | ------------------------------------------------------------------------------- |
| Core split       | Git repository = mutable state/control layer + immutable content/evidence layer |
| Stable invariant | Content is addressed by hash; state points at content                           |
| Workflow rule    | Workflows mutate state and sometimes create content                             |
| Adapter role     | Adapter reads Git state/content and normalizes facts                            |
| CUE role         | CUE owns schema, validation, projection, and gates                              |
| Anti-pattern     | Do not let the `go-git` object model become the schema                          |

## Tier ladder matrix

| Tier | Objective                     | Git primitives admitted                                      | Layer           | Output / gate                              |
| ---: | ----------------------------- | ------------------------------------------------------------ | --------------- | ------------------------------------------ |
|    0 | CUE project shell             | None                                                         | None            | CUE module exists                          |
|    1 | State contracts               | repo root, HEAD, branch, refs, index, worktree, status       | State           | `#GitStateFacts`                           |
|    2 | CUE probing scripts           | Same as Tier 1, observed through direct `git` probes         | State           | `_tool.cue → tool/exec → git`              |
|    3 | Content contracts             | object hash, blob, tree, commit, parent edge, tag object     | Content         | `#GitContentFacts`                         |
|    4 | Workflow transition contracts | add, commit, checkout, branch, merge, reset                  | State ↔ content | `#GitTransition`                           |
|    5 | Go adapter over `go-git`      | state reader + content reader                                | Adapter         | `gitfacts state/content/facts .`           |
|    6 | Unified CUE fact graph        | `#GitStateFacts + #GitContentFacts`                          | Schema          | `#GitFacts` validated by CUE               |
|    7 | CUE projections/gates         | dirty gate, detached warning, graph summary, readiness gates | Derived         | accepted facts → decisions                 |
|    8 | Custom CUE flow host          | No new primitives                                            | Execution       | same model, stronger execution integration |

## Primitive ordering matrix

| Order | Primitive group      | Why it comes here                          |
| ----: | -------------------- | ------------------------------------------ |
|     1 | State primitives     | Explain current repo position              |
|     2 | Content primitives   | Explain what state points at               |
|     3 | Workflow transitions | Explain how state creates or moves content |
|     4 | Adapter              | Must preserve state/content distinction    |
|     5 | CUE projection       | Validates and derives from both layers     |

## Layer matrix

| Layer      | Question answered                                  | Primitives                                               | Schema target                    |
| ---------- | -------------------------------------------------- | -------------------------------------------------------- | -------------------------------- |
| State      | Where is the repo positioned right now?            | repo root, HEAD, branch, refs, index, worktree, status   | `#GitStateFacts`                 |
| Content    | What exists in the durable Git object graph?       | object hash, blob, tree, commit, parent edge, tag object | `#GitContentFacts`               |
| Transition | How does state produce or move content?            | edit, add, commit, checkout, branch, merge, reset        | `#GitTransition`                 |
| Adapter    | How are Git internals observed and normalized?     | state reader, content reader, normalizers                | JSON facts emitted by `gitfacts` |
| Projection | What decisions can be derived from accepted facts? | dirty gate, graph summary, workflow readiness            | CUE gates/projections            |

## Workflow transition matrix

| Workflow  | Reads                             | Writes                                       | Meaning                                                         |
| --------- | --------------------------------- | -------------------------------------------- | --------------------------------------------------------------- |
| Edit file | Worktree                          | Worktree state                               | Creates dirty mutable filesystem state                          |
| Add       | Worktree                          | Index, staged blob/tree candidate            | Moves worktree changes toward content creation                  |
| Commit    | Index, HEAD, parent commit/tree   | Commit object, tree/blob objects, branch ref | Turns staged state into durable content and moves state pointer |
| Checkout  | HEAD/ref, tree                    | HEAD, index, worktree                        | Repositions current state to existing content                   |
| Branch    | Current commit/ref                | New ref                                      | Creates movable pointer without new content                     |
| Merge     | Two commit tips                   | Maybe merge commit, branch ref               | Combines histories and moves current branch                     |
| Reset     | Ref/index/worktree depending mode | Ref/index/worktree                           | Repoints or rewinds state, usually without new content          |

## Adapter normalization matrix

| Internal source                   | Adapter step                                            | External fact model |
| --------------------------------- | ------------------------------------------------------- | ------------------- |
| `go-git` repository               | `gitrepo/open.go`                                       | repo-bound facts    |
| `go-git` HEAD/refs/status         | `facts/state.go` + `normalize/status.go`, `refs.go`     | `#GitStateFacts`    |
| `go-git` commits/trees/blobs/tags | `facts/content.go` + `normalize/commits.go`, `trees.go` | `#GitContentFacts`  |
| Combined state/content reader     | `facts/all.go`                                          | `#GitFacts`         |

## Compressed final model

| Component       | Authority                     | Output                             |
| --------------- | ----------------------------- | ---------------------------------- |
| Git             | Source of state/content truth | repository facts                   |
| Go adapter      | Observation + normalization   | JSON fact payloads                 |
| CUE schema      | Contract authority            | validation                         |
| CUE projections | Decision authority            | gates, summaries, readiness checks |
| Flow host       | Execution integration         | same facts, less shell boundary    |
