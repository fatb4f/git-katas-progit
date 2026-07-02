# Task — 09-message-author-date-filter

Use the prepared repository fixture. Do not mutate history unless the task explicitly asks for it.

Run the primary command family:

```bash
git log --grep="release"
git log --author="Ada"
git log --since="2024-01-02" --until="2024-01-04"
```

Write:

- commits by Ada to `.answers/author_matches`
- commits whose subject/body matches `release` to `.answers/message_matches`
- commits inside the date range to `.answers/date_range_matches`
