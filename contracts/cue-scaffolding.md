
Yes. **Scaffold-first is cleaner than snippet-first.**

The better architecture is:

```text
CUE constructors
  → CUE scaffold/template catalog
  → cue export / cue cmd materialization
  → generated files
  → optional Neovim snippets generated from the same catalog
```

So Neovim should not be the main authoring surface. It should consume generated artifacts.

---

# Revised position

## Snippet-first

```text
Neovim snippet expands partial CUE
  → user edits manually
  → CUE validates later
```

Problem: snippets are ergonomic, but weak as authority. They are editor-local text macros.

## Scaffold-first

```text
CUE model defines templates
  → cue cli materializes complete files
  → Neovim edits concrete generated/seeded files
  → CUE validates generated files
```

This is stronger because the generation surface is still inside the lattice.

---

# Recommended model

## 1. Keep `constructors.cue` as the kernel

Current authority file already defines the useful constructor base:

```cue
#MakeClosedObligationState
#MakePositiveFixture
#MakeNegativeFixture
#MakeSubsumption
#MakeGeneratedAssertionMatrix
#MakeValidationPlan
#MakeCompletionReport
```

This should remain the **semantic kernel**.

It should not know about Neovim, LuaSnip, file paths, or editor expansion behavior.

---

## 2. Add a scaffold projection layer

Suggested layout:

```text
.github/contracts/
├── constructors.cue
└── scaffolds/
    ├── schema.cue
    ├── catalog.cue
    ├── projection.cue
    └── gen_tool.cue
```

The scaffold layer owns generated file intent.

---

# Scaffold schema

```cue
package scaffolds

import "strings"

#ScaffoldKind:
	"contract" |
	"fixture" |
	"validation-plan" |
	"completion-report" |
	"nvim-snippet" |
	"nvim-template"

#MaterializedFile: close({
	id:       =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	kind:     #ScaffoldKind
	path:     string & !=""
	lines:    [...string] & [_, ...]
	contents: strings.Join(lines, "\n") + "\n"
})

#ScaffoldCatalog: close({
	files: {
		[string]: #MaterializedFile
	}
})
```

This gives you a stable contract:

```text
input:  named scaffold definitions
output: materialized files with paths + contents
```

---

# Example scaffold catalog

```cue
package scaffolds

contractModule: #MaterializedFile & {
	id:   "contract-module"
	kind: "contract"
	path: ".github/contracts/generated/example.contract.cue"

	lines: [
		"package impl",
		"",
		"state: #CodexObligationState & {",
		"\tid: \"${STATE_ID}\"",
		"",
		"\tartifacts: {}",
		"\tactions: {}",
		"\tchecks: {}",
		"\tevidence: {}",
		"}",
		"",
		"closed: (#MakeClosedObligationState & {",
		"\tin: state",
		"}).out",
		"",
		"matrix: (#MakeGeneratedAssertionMatrix & {",
		"\tin: state: state",
		"}).out",
	]
}

fixtureModule: #MaterializedFile & {
	id:   "fixture-module"
	kind: "fixture"
	path: ".github/contracts/generated/example.fixtures.cue"

	lines: [
		"package impl",
		"",
		"positive: (#MakePositiveFixture & {",
		"\tin: {",
		"\t\tid: \"valid-state\"",
		"\t\tdescription: \"Candidate state must unify with authority\"",
		"\t\tauthority: authorityState",
		"\t\tcandidate: candidateState",
		"\t}",
		"}).out",
		"",
		"negative: (#MakeNegativeFixture & {",
		"\tin: {",
		"\t\tid: \"invalid-state\"",
		"\t\tdescription: \"Invalid state must bottom against authority\"",
		"\t\tauthority: authorityState",
		"\t\tinvalid: invalidState",
		"\t}",
		"}).out",
	]
}

catalog: #ScaffoldCatalog & {
	files: {
		contractModule.id: contractModule
		fixtureModule.id:  fixtureModule
	}
}
```

This creates **full-file scaffolds**, not editor fragments.

---

# Materialization options

## Option A — Pure export + shell adapter

Most deterministic and easiest to test.

```bash
cue export .github/contracts/scaffolds -e catalog.files --out json
```

Then a small adapter writes each file:

```text
catalog.files[*].path
catalog.files[*].contents
```

This keeps CUE hermetic and pushes filesystem mutation into `just`, Bash, Python, or Go.

Recommended for your current architecture because it matches:

```text
CUE = authority
just = controller
adapter = mutation actuator
```

---

## Option B — `cue cmd` with `tool/file`

Use this only when you want CUE itself to own the effectful materialization command.

Conceptual shape:

```cue
package scaffolds

import "tool/file"

command: scaffold: {
	for id, f in catalog.files {
		"\(id)": file.Create & {
			filename: f.path
			contents: f.contents
		}
	}
}
```

Then:

```bash
cue cmd scaffold .github/contracts/scaffolds
```

This is convenient, but it makes the CUE package effectful. I would keep this in a dedicated `_tool.cue` file only.

---

# Neovim integration model

Neovim should call the scaffold actuator, not own the templates.

## Example commands

```lua
vim.api.nvim_create_user_command("CueScaffoldContract", function()
  vim.system({ "just", "cue-scaffold-contract" }, { text = true })
end, {})

vim.api.nvim_create_user_command("CueScaffoldFixtures", function()
  vim.system({ "just", "cue-scaffold-fixtures" }, { text = true })
end, {})
```

Then `just` owns the bridge:

```just
cue-scaffold-contract:
    cue export .github/contracts/scaffolds -e catalog.files.contract-module.contents --out text > .github/contracts/generated/example.contract.cue

cue-scaffold-fixtures:
    cue export .github/contracts/scaffolds -e catalog.files.fixture-module.contents --out text > .github/contracts/generated/example.fixtures.cue
```

For multiple files, use a small adapter:

```text
cue export → JSON file manifest → adapter writes paths
```

---

# Where snippets still fit

Snippets become a **derived interface**, not the primary interface.

```text
same scaffold catalog
  → full-file templates
  → optional VSCode/LuaSnip snippets
```

Useful generated snippets:

```text
caction
cartifact
ccheck
cevidence
cpos
cneg
csub
cmatrix
cvplan
creport
```

But they should be generated from the same catalog or from a sibling `snippet.catalog.cue`.

---

# Better final structure

```text
.github/contracts/
├── constructors.cue
├── scaffolds/
│   ├── schema.cue
│   ├── catalog.cue
│   ├── projection.cue
│   └── scaffold_tool.cue
└── generated/
    ├── example.contract.cue
    ├── example.fixtures.cue
    └── validation.plan.cue

.config/nvim/
├── lua/
│   └── cue_scaffold.lua
└── snippets/
    ├── package.json
    └── snippets/
        └── cue.json
```

---

# Control boundary

## CUE owns

```text
template identity
template kind
allowed output paths
file contents
constructor usage
validation plan
completion report contract
```

## Adapter owns

```text
filesystem writes
overwrite policy
directory creation
formatting
git diff display
```

## Neovim owns

```text
commands
keymaps
picker UI
opening generated files
optional snippet expansion
```

---

# Recommended first implementation slice

Build only this first:

```text
.github/contracts/scaffolds/schema.cue
.github/contracts/scaffolds/catalog.cue
.github/contracts/scaffolds/projection.cue
just cue-scaffold-list
just cue-scaffold-write
just cue-scaffold-check
```

Minimum generated files:

```text
generated/contract.cue
generated/fixtures.cue
generated/validation.cue
```

Then add Neovim commands:

```text
:CueScaffoldContract
:CueScaffoldFixtures
:CueScaffoldValidation
```

Only after that, generate snippets.

---

# Final model

```text
constructors.cue
  = semantic authority

scaffolds/*.cue
  = template authority

cue export / cue cmd
  = materialization control surface

just / adapter
  = mutation actuator

neovim
  = invocation and editing surface

snippets
  = optional generated convenience layer
```

So yes: **use the CUE CLI to materialize templates first. Generate snippets only as a secondary ergonomic projection.**
