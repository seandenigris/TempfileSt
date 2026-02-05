Class {
	#name : 'TempfileSpecification',
	#superclass : 'TestCase',
	#category : 'Tempfile-Specification',
	#package : 'Tempfile',
	#tag : 'Specification'
}

{ #category : 'tests' }
TempfileSpecification >> testCreatingWithSuffix [
	| instance suffix |
	suffix := '-000.jpg'.
	instance := Tempfile withSuffix: suffix.
	self assert: (instance basename endsWith: suffix)
]

{ #category : 'tests' }
TempfileSpecification >> testNew [
	| instance |
	instance := Tempfile new.
	instance parent asFileReference should equal: (FileLocator temp / 'pharo-tempfile') asFileReference.
]

{ #category : 'private' }
TempfileSpecification >> test_deleteAfter_DeletesExisting: creationBlock [
	| instance |
	Tempfile new deleteAfter: [ :tf | 
		instance := tf.
		tf exists should be: false.
		creationBlock value: tf.
		tf exists should be: true ].
	instance exists should be: false.
]

{ #category : 'tests' }
TempfileSpecification >> test_deleteAfter_DeletesExistingDirectory [

	self test_deleteAfter_DeletesExisting: [ :tf | 
		tf ensureCreateDirectory.
		(tf / 'file1.txt') ensureCreateFile ].
]

{ #category : 'tests' }
TempfileSpecification >> test_deleteAfter_DeletesExistingFile [

	self test_deleteAfter_DeletesExisting: #ensureCreateFile.
]

{ #category : 'tests' }
TempfileSpecification >> test_deleteAll [
	3 timesRepeat: [ Tempfile new ensureCreateFile ].
	3 timesRepeat: [ Tempfile new ensureCreateDirectory ].
	Tempfile rootFolder hasChildren should be: true.
	
	Tempfile deleteAll.
	
	Tempfile rootFolder exists should be: true.
	Tempfile rootFolder hasChildren should be: false.
	
]
