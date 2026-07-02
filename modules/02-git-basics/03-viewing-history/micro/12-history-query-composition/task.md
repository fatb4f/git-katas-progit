# Task — 12-history-query-composition

Use the prepared repository fixture. Do not mutate history unless the task explicitly asks for it.

Run the primary command family:

```bash
git log v1.0..HEAD --graph --oneline --author="Ada" --grep="release" -- app/config.txt
```

Write:

- commits returned by the composed query to `.answers/composed_query_result`
- a short explanation of each filter in the command to `.answers/explain_filter_chain`
