package curriculum

#Chapter: {
	id:       string
	title:    string
	proGit:   string
	sections: [...#Section]
}

#Section: {
	id:       string
	title:    string
	proGit:   string
	upstream: [...string]
	micro:    [...#MicroKata]
}

#MicroKata: {
	id:        string
	name:      string
	kind:      "mutation" | "inspection" | "recovery" | "internals"
	requires?: [...string]
	commands:  [...string]
	concepts:  [...string]
	fixture: {
		shape: string
	}
	verify: {
		mode:   "state" | "answer" | "command-output" | "mixed"
		checks: [...string]
	}
}

chapters: [
	{
		id:     "02"
		title:  "Git Basics"
		proGit: "https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository"
		sections: [
			{
				id:       "01"
				title:    "Getting a Git Repository"
				proGit:   "https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository"
				upstream: ["setup", "new"]
				micro: []
			},
			{
				id:       "02"
				title:    "Recording Changes to the Repository"
				proGit:   "https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository"
				upstream: ["basic-staging", "basic-commits", "ignore"]
				micro: []
			},
			{
				id:       "03"
				title:    "Viewing the Commit History"
				proGit:   "https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History"
				upstream: ["basic-commits", "basic-staging", "basic-branching", "ff-merge", "3-way-merge", "git-tag", "investigation", "bisect", "Objects"]
				micro: []
			},
			{
				id:       "04"
				title:    "Undoing Things"
				proGit:   "https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things"
				upstream: ["amend", "reset", "basic-revert", "save-my-commit"]
				micro: []
			},
			{
				id:       "05"
				title:    "Working with Remotes"
				proGit:   "https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes"
				upstream: ["new", "remote-related"]
				micro: []
			},
			{
				id:       "06"
				title:    "Tagging"
				proGit:   "https://git-scm.com/book/en/v2/Git-Basics-Tagging"
				upstream: ["git-tag"]
				micro: []
			},
		]
	},
]
