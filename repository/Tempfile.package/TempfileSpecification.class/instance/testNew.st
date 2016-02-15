tests
testNew
	| instance |
	instance := Tempfile new.
	self assert: (instance isKindOf: Tempfile).
	self assert: instance parent fullName equals: (FileLocator imageDirectory / 'tmp') fullName