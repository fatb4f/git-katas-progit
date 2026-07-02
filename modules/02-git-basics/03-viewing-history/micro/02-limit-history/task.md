# Task — 02-limit-history

Use the prepared repository fixture. Do not mutate history unless the task explicitly asks for it.

Run the primary command family:

```bash
git log -2
git log --since="2024-01-03"
git log --until="2024-01-03"
```

Write:

- commits returned by the count limit to `.answers/latest_two_commits`
- commits returned by the since-date filter to `.answers/commits_after_date`
- commits returned by the until-date filter to `.answers/commits_before_date`
