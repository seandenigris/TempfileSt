"
For more inspiration, maybe see http://ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html
"
Class {
	#name : #Tempfile,
	#superclass : #FileLocator,
	#category : 'Tempfile-Core'
}

{ #category : #'instance creation' }
Tempfile class >> do: aBlock [
	| instance |
	instance := self new.
	aBlock value: instance.
	instance exists ifTrue: [ instance deleteAll ]
]

{ #category : #'instance creation' }
Tempfile class >> endingWith: aString [
	| filename |
	filename := DateAndTime now printString select: [ :c | c isAlphaNumeric or: [ '$-' includes: c ] ].
	^ FileLocator temp / (filename, aString).
]

{ #category : #'instance creation' }
Tempfile class >> new [
	^ self endingWith: ''.
]
