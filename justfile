list:
	find modules -maxdepth 4 -type d | sort

index:
	cue eval ./...

pack:
	zip -r git-katas-progit.zip .
