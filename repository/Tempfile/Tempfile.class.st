"
For more inspiration, maybe see http://ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html
"
Class {
	#name : #Tempfile,
	#superclass : #FileLocator,
	#category : #'Tempfile-Core'
}

{ #category : #'instance creation' }
Tempfile class >> defaultFilename [
	^ DateAndTime now printString select: [ :c | c isAlphaNumeric or: [ '$-' includes: c ] ].
]

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
	self
		deprecated: 'endingWith: has been replaced by withSuffix:'
		transformWith: '`@receiver endingWith: `@argument' 
			-> '`@receiver withSuffix: `@argument'.
	^ self withSuffix: aString
]

{ #category : #accessing }
Tempfile class >> exampleWithPrefix [
	<gtExample>
	| file |
	file := self withPrefix: 'prefix'.
	self assert: (file base beginsWith: 'prefix').
	^ file
]

{ #category : #accessing }
Tempfile class >> exampleWithSuffix [
	<gtExample>
	| file |
	file := self withSuffix: 'Suffix'.
	self assert: (file base endsWith: 'Suffix').
	^ file
]

{ #category : #'instance creation' }
Tempfile class >> new [
	^ self withSuffix: ''
]

{ #category : #'instance creation' }
Tempfile class >> temp [
	^ super temp / 'pharo-tempfile'
]

{ #category : #'instance creation' }
Tempfile class >> withPrefix: aString [
	^ self temp / (aString, self defaultFilename).
]

{ #category : #'instance creation' }
Tempfile class >> withSuffix: aString [
	"aString - suffix e.g. `-abc.txt`; could be/contain an extension, but doesn't have to"
	^ self temp / (self defaultFilename, aString).
]

{ #category : #enumerating }
Tempfile >> deleteAfter: aBlock [
	[ aBlock value: self ]
		ensure: [ self exists ifTrue: [ self deleteAll ] ]
]
