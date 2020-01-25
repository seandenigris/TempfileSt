"
For more inspiration, maybe see http://ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html
"
Class {
	#name : #Tempfile,
	#superclass : #FileLocator,
	#category : 'Tempfile-Core'
}

{ #category : #modifying }
Tempfile class >> deleteAll [
	self temp deleteAllChildren
]

{ #category : #'instance creation' }
Tempfile class >> do: aBlock [
	self new deleteAfter: aBlock.

]

{ #category : #'instance creation' }
Tempfile class >> endingWith: aString [
	"aString - suffix e.g. `-abc.txt`; could be/contain an extension, but doesn't have to"
	| filename |
	filename := DateAndTime now printString select: [ :c | c isAlphaNumeric or: [ '$-' includes: c ] ].
	^ self temp / (filename, aString).
]

{ #category : #'instance creation' }
Tempfile class >> new [
	^ self endingWith: ''.
]

{ #category : #'instance creation' }
Tempfile class >> temp [
	^ super temp / 'pharo-tempfile'
]

{ #category : #enumerating }
Tempfile >> deleteAfter: aBlock [
	[ aBlock value: self ]
		ensure: [ self exists ifTrue: [ self deleteAll ] ]
]
