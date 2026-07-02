# Verification — 06-path-limited-history

Verification mode: answer.

Check:

- `.answers/only_commits_touching_path` contains only commits that touch `app/config.txt`.
- `.answers/excluded_unrelated_commit` names a reachable commit omitted by the path-limited query.
