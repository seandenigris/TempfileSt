tests
testNew
	| instance |
	instance := Tempfile new.
	self assert: instance parent fullName equals: FileLocator temp fullName