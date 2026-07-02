package kata

kata: {
	id:    "02.03.05"
	name:  "name-status-history"
	kind:  "inspection"
	level: "L1"
	source: {upstream: ["basic-staging", "ignore", "git-rm"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log --name-only", "git log --name-status"]
	concepts: ["path", "add", "modify", "delete", "rename preview"]
	fixture: {name: "file-evolution", shape: "files added modified and deleted"}
	task: {
		prompt:  "Classify commits that added, modified, and deleted files."
		outputs: [".answers/added_file_commit", ".answers/deleted_file_commit", ".answers/modified_file_commits"]
	}
	verify: {mode: "answer", checks: ["added_file_commit", "deleted_file_commit", "modified_file_commits"]}
}
