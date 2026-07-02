# Verification — 05-name-status-history

Verification mode: answer.

Check:

- `.answers/added_file_commit` matches the commit with `A` status for the target file.
- `.answers/deleted_file_commit` matches the commit with `D` status for the target file.
- `.answers/modified_file_commits` matches commits with `M` status for the target file.
