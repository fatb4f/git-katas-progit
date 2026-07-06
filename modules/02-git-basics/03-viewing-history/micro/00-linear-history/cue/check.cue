package cuetool

check: {
	constructor: "contracts/constructors.cue"
	closed: plan.closed
	items: ["read refs", "write refs", "create refs", "gates", "witnesses"]
}
