package schema

#ReportSection: {
	id: #KebabIdentifier
	title: #NonEmptyString
	description: #NonEmptyString
	derivesFrom: #NonEmptyStringList
	render: {
		kind: "table" | "list" | "object" | "paragraph"
		sourcePaths: #NonEmptyStringList
	}
}

#ReportProjection: {
	id: #NonEmptyString
	format: "markdown" | "json" | "cue"
	audience: "human" | "agent" | "api" | *"agent"
	sections: [...#ReportSection] & [_, ...]
}
