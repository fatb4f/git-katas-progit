package schema

import "strings"

#NonEmptyString: string & strings.MinRunes(1)
#NonEmptyStringList: [...#NonEmptyString] & [_, ...]
#KebabIdentifier: #NonEmptyString & =~"^[a-z0-9]+(-[a-z0-9]+)*$"
#DottedKataID: #NonEmptyString & =~"^[0-9]{2}\\.[0-9]{2}\\.[0-9]{2}$"
#RelativePath: #NonEmptyString & !~"^/"
#Level: "L1" | "L2" | "L3"

#PlaneSpec: {
	path: #RelativePath
	required: bool | *true
	description: #NonEmptyString
}

#KataDirectory: {
	id: #DottedKataID
	slug: #KebabIdentifier
	path: #RelativePath
	level: #Level

	planes: {
		theory: #PlaneSpec & {
			path: "theory"
			description: "SCM and Git theory for the repository-analysis problem."
		}
		lattice: #PlaneSpec & {
			path: "lattice"
			description: "Lattice expression of the analysis problem, refinements, witnesses, and bottom cases."
		}
		micro: #PlaneSpec & {
			path: "micro"
			description: "Learner-facing micro-kata task and answer surface."
		}
		cue: #PlaneSpec & {
			path: "cue"
			description: "CUE workflow that resolves, validates, and reports the analysis."
		}
	}

	files: {
		readme: "README.md"
		directory: "directory.cue"
	}

	refs: {
		theory: #NonEmptyString
		lattice: #NonEmptyString
		micro: #NonEmptyString
		tool: #NonEmptyString
		report: #NonEmptyString
	}
}
