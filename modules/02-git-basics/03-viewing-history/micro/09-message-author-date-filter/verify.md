# Verification — 09-message-author-date-filter

Verification mode: answer.

Check:

- `.answers/author_matches` contains commits matching `--author="Ada"`.
- `.answers/message_matches` contains commits matching `--grep="release"`.
- `.answers/date_range_matches` contains commits inside the specified date range.
