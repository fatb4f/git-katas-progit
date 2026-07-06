package schema

#ReportSection: {
	id: #KebabIdentifier
	title: #NonEmptyString
	description: #NonEmptyString
}

#ReportProjection: {
	id: #NonEmptyString
	format: "markdown" | "json" | "cue"
	sections: [...#ReportSection] & [_, ...]
}
