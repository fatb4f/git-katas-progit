package kata

kata: {
	id:    "02.03.11"
	name:  "tag-decorated-history"
	kind:  "inspection"
	level: "L2"
	source: {upstream: ["git-tag"], proGit: "Git Basics / Viewing the Commit History"}
	commands: ["git log --decorate", "git log v1.0..HEAD"]
	concepts: ["tag ref", "decoration", "range", "release boundary"]
	fixture: {name: "tagged-release", shape: "several commits with two tags"}
	task: {
		prompt:  "Identify the commit tagged as v1.0 and commits after that tag."
		outputs: [".answers/tagged_commit", ".answers/commits_after_tag"]
	}
	verify: {mode: "answer", checks: ["tagged_commit", "commits_after_tag"]}
}
