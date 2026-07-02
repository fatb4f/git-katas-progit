package kata

kata: {
	id:    "02.03.06"
	name:  "path-limited-history"
	kind:  "inspection"
	level: "L2"
	source: {upstream: ["basic-staging", "investigation"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log -- app/config.txt"]
	concepts: ["pathspec", "file history", "filtered reachability"]
	fixture: {name: "file-evolution", shape: "one file changed in non-consecutive commits"}
	task: {
		prompt:  "List only commits touching the target path and identify an unrelated commit that is excluded."
		outputs: [".answers/only_commits_touching_path", ".answers/excluded_unrelated_commit"]
	}
	verify: {mode: "answer", checks: ["only_commits_touching_path", "excluded_unrelated_commit"]}
}
