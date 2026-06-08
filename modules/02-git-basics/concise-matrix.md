# Chapter 2 Concise Matrix

| Pro Git section | State primitive | Existing kata source | Micro-kata output |
|---|---|---|---|
| Getting a Repository | `.git`, object DB, initial refs | setup/new | learner can create/acquire a repo and locate Git metadata |
| Recording Changes | working tree, index, commit | basic-staging, basic-commits, ignore | learner can stage and commit controlled changes |
| Viewing History | commit graph, parents, metadata, patches | cross-cutting | learner can query history by shape, range, path, metadata, topology |
| Undoing Things | index/worktree/ref movement, inverse commits | amend, reset, revert, save-my-commit | learner can safely undo by intent and inspect consequences |
| Remotes | local refs, remote refs, tracking refs | remote/new | learner can fetch/push and inspect local vs remote state |
| Tagging | tag refs, annotated tag objects | git-tag | learner can create/read stable commit labels |

## Chapter 2 Micro-Kata Skeleton

| ID | Section | Micro-katas |
|---:|---|---|
| 02.01 | repository | init, clone, inspect `.git` |
| 02.02 | recording | status, add, commit, ignore, remove |
| 02.03 | history | log, oneline, patch, stat, path, graph, filters, pickaxe |
| 02.04 | undo | amend, unstage, restore, revert, reset variants |
| 02.05 | remotes | add remote, fetch, push, pull, tracking |
| 02.06 | tagging | lightweight tag, annotated tag, show tag, tag ranges |

## Command Families

| Family | Commands | Primary section |
|---|---|---|
| repository | `git init`, `git clone` | 02.01 |
| state observation | `git status`, `git diff` | 02.02 |
| recording | `git add`, `git commit`, `.gitignore` | 02.02 |
| history query | `git log`, `git show` | 02.03 |
| undo | `git commit --amend`, `git restore`, `git reset`, `git revert` | 02.04 |
| remote | `git remote`, `git fetch`, `git push`, `git pull` | 02.05 |
| tag | `git tag`, `git show`, `git log --decorate` | 02.06 |
