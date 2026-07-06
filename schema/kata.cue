package schema

#KataSource: {
	proGit: #NonEmptyString
	upstream: #NonEmptyStringList
}

#LearnerTask: {
	objective: #NonEmptyString
	commandFamily: #NonEmptyStringList
	outputs: #NonEmptyStringList
	fixture: #NonEmptyString
}

#MicroKata: {
	id: #DottedKataID
	slug: #KebabIdentifier
	level: #Level
	section: #KebabIdentifier

	source: #KataSource
	learner: #LearnerTask

	refs: {
		analysisConcept: #NonEmptyString
		latticeExpression: #NonEmptyString
		workflow: #NonEmptyString
		report: #NonEmptyString
	}
}
