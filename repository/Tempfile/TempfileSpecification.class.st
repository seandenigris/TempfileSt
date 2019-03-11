Class {
	#name : #TempfileSpecification,
	#superclass : #TestCase,
	#category : 'Tempfile-Specification'
}

{ #category : #tests }
TempfileSpecification >> testCreatingWithSuffix [
	| instance suffix |
	suffix := '-000.jpg'.
	instance := Tempfile endingWith: suffix.
	self assert: (instance basename endsWith: suffix)
]

{ #category : #tests }
TempfileSpecification >> testDoDeletesExisting: creationBlock [
	| instance |
	Tempfile do: [ :tf | 
		instance := tf.
		tf exists should beFalse.
		creationBlock value: tf.
		tf exists should beTrue ].
	instance exists should beFalse.
]

{ #category : #tests }
TempfileSpecification >> testDoDeletesExistingDirectory [

	self testDoDeletesExisting: [ :tf | 
		tf ensureCreateDirectory.
		(tf / 'file1.txt') ensureCreateFile ].
]

{ #category : #tests }
TempfileSpecification >> testDoDeletesExistingFile [

	self testDoDeletesExisting: #ensureCreateFile.
]

{ #category : #tests }
TempfileSpecification >> testNew [
	| instance |
	instance := Tempfile new.
	self assert: instance parent fullName equals: FileLocator temp fullName
]
