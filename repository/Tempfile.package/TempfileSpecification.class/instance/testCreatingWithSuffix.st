tests
testCreatingWithSuffix
	| instance suffix |
	suffix := '-000.jpg'.
	instance := Tempfile endingWith: suffix.
	self assert: (instance basename endsWith: suffix)