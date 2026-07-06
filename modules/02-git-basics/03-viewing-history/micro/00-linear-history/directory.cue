package linearhistory

import schema "example.com/git-katas-progit/schema:schema"

directory: schema.#KataDirectory & {
	id: "02.03.00"
	slug: "linear-history"
	path: "modules/02-git-basics/03-viewing-history/micro/00-linear-history"
	level: "L1"

	refs: {
		theory: "scm.history.linear-provenance"
		lattice: "lattice.history.linear-provenance"
		micro: "micro.linear-history"
		tool: "cue.git.history.linear-provenance"
		report: "report.history.linear-provenance"
	}
}
