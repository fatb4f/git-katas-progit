# Verification — 11-tag-decorated-history

Verification mode: answer.

Check:

- `.answers/tagged_commit` matches the commit decorated by `v1.0`.
- `.answers/commits_after_tag` contains commits reachable from `HEAD` and not from `v1.0`.
