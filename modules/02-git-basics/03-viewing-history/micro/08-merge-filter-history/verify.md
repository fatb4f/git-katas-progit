# Verification — 08-merge-filter-history

Verification mode: answer.

Check:

- `.answers/merge_commit` matches the commit returned by `git log --merges`.
- `.answers/merge_parents` matches both parents shown by `git show --summary`.
- `.answers/non_merge_count` matches the count returned by `git log --no-merges`.
