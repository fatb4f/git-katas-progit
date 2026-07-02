# Task — 08-merge-filter-history

Use the prepared repository fixture. Do not mutate history unless the task explicitly asks for it.

Run the primary command family:

```bash
git log --merges
git log --no-merges
git show --summary
```

Write:

- merge commit hash to `.answers/merge_commit`
- merge parent hashes to `.answers/merge_parents`
- number of non-merge commits to `.answers/non_merge_count`
