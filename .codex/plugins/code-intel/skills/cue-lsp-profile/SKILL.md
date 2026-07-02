---
name: code-intel-cue-lsp
description: Use the repository-local CUE-only code intelligence profile.
---

# Code Intel: CUE LSP Profile

Use this skill when working on `git-katas-progit` CUE curriculum contracts.

1. Read `index.cue` and relevant `modules/**/*.cue` files before changing curriculum structure.
2. Use CUE files as authority for IDs, command lists, fixture shape, and verification modes.
3. Treat LSP diagnostics and generated JSON as evidence only.
4. Keep this profile limited to CUE LSP until another provider is explicitly added.

Validation:

```sh
cue eval ./...
```
