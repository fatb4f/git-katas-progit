---
name: code-intel-cue-lsp
description: Use the repository-local CUE-only code intelligence profile.
---

# Code Intel: CUE LSP Profile

This profile is intentionally limited to CUE language-server support for `git-katas-progit`.

## Authority Boundary

1. Treat repository CUE files as source authority for curriculum structure and micro-kata contracts.
2. Treat LSP diagnostics, generated JSON, and tool output as evidence only.
3. Do not infer authority from markdown prose when nearby CUE contracts disagree.
4. Do not activate non-CUE providers from this profile.

## Included Provider

- `cue-lsp`: CUE files under `index.cue` and `modules/**/*.cue`.

## Excluded Providers

- Markdown language services
- Git command analysis providers
- Fixture execution providers
- Lua, WezTerm, and Neovim providers
- MCP-derived mutation providers

## Validation

```sh
cue eval ./...
```
