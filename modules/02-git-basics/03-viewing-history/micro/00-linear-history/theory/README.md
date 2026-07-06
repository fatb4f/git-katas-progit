# Theory — Linear History Provenance

## SCM question

What are the newest and oldest commits reachable from `HEAD`, and what provenance metadata is attached to the newest commit?

## Git theory

`git log` is a read-only projection over the commit graph. In the simplest linear case, the selected history is a single parent chain reachable from `HEAD`.

The command exposes:

- commit identity through object IDs;
- reachability from the selected ref;
- parent ordering through commit ancestry;
- author/date/message metadata;
- default newest-first presentation.

## Repository-analysis role

This is the base provenance read used before mutation. Before an operator or agent amends, resets, reverts, rebases, cherry-picks, or prepares a report, it needs a closed understanding of the current history boundary and metadata.

## Required facts

- `head-ref`
- `reachable-commit-list`
- `commit-parent-map`
- `commit-author-map`
- `commit-subject-map`

## Required witnesses

- newest commit;
- oldest commit;
- newest author;
- newest subject;
- linearity of the selected history.
