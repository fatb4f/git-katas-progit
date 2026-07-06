package micro

import schema "example.com/git-katas-progit/schema:schema"

kata: schema.#MicroKata & {
	id: "02.03.00"
	slug: "linear-history"
	level: "L1"
	section: "viewing-history"

	source: {
		proGit: "Git Basics / Viewing the Commit History"
		upstream: ["basic-commits"]
	}

	learner: {
		objective: "Identify newest and oldest commits plus newest commit provenance."
		commandFamily: ["git log"]
		outputs: [
			".answers/newest_commit",
			".answers/oldest_commit",
			".answers/author_field",
			".answers/commit_subject",
		]
		fixture: "linear-5"
	}

	refs: {
		analysisConcept: "scm.history.linear-provenance"
		latticeExpression: "lattice.history.linear-provenance"
		workflow: "cue.git.history.linear-provenance"
		report: "report.history.linear-provenance"
	}
}
