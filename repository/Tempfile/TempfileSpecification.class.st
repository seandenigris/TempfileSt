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
TempfileSpecification >> testNew [
	| instance |
	instance := Tempfile new.
	instance parent asFileReference should equal: (FileLocator temp / 'pharo-tempfile') asFileReference.
]

{ #category : #private }
TempfileSpecification >> test_deleteAfter_DeletesExisting: creationBlock [
	| instance |
	Tempfile new deleteAfter: [ :tf | 
		instance := tf.
		tf exists should beFalse.
		creationBlock value: tf.
		tf exists should beTrue ].
	instance exists should beFalse.
]

{ #category : #tests }
TempfileSpecification >> test_deleteAfter_DeletesExistingDirectory [

	self test_deleteAfter_DeletesExisting: [ :tf | 
		tf ensureCreateDirectory.
		(tf / 'file1.txt') ensureCreateFile ].
]

{ #category : #tests }
TempfileSpecification >> test_deleteAfter_DeletesExistingFile [

	self test_deleteAfter_DeletesExisting: #ensureCreateFile.
]

{ #category : #tests }
TempfileSpecification >> test_deleteAll [
	3 timesRepeat: [ Tempfile new ensureCreateFile ].
	3 timesRepeat: [ Tempfile new ensureCreateDirectory ].
	Tempfile temp hasChildren should beTrue.
	
	Tempfile deleteAll.
	
	Tempfile temp exists should beTrue.
	Tempfile temp hasChildren should beFalse.
	
]
