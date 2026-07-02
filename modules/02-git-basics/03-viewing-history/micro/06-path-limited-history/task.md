# Task — 06-path-limited-history

Use the prepared repository fixture. Do not mutate history unless the task explicitly asks for it.

Run the primary command family:

```bash
git log -- app/config.txt
```

Write:

- commits that touch `app/config.txt` to `.answers/only_commits_touching_path`
- one unrelated commit excluded by the path filter to `.answers/excluded_unrelated_commit`
