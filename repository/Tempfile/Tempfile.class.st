"
My reason for existence is to provide access to ''some'' unique location on the filesystem where it is safe to perform any operation - even destructive ones. Users ''don't have to care'' where my underlying file actually lives. Think of me as a ${class:FileLocator}$ with two special properties:
# Each instance of me will point to a unique underlying temp file location.
# The file I represent will be automatically deleted from the filesystem when I am garbage collected.
!Location on Filesystem
Although you can just happily use my file - create, write, delete - without worrying, if you're interested in specifics, the location I point to will be somewhere inside my ${method:Tempfile class>>#rootFolder}$.
!Automatic Deletion
There are two things you should know:
# You are welcome to manually delete my file if you don't want to wait for me to be garbage collected.
# Any references you create from me will be ordinary file references, not Tempfiles. For example, ${example:Tempfile class>>#exampleDerivativeFile}$
NB. Some OSs automatically delete temp files under certain conditions (e.g. *MacOS after unaccessed for three days>https://superuser.com/a/187105*). If this is undesirable for your use case, you may want to override me and change my root folder.
!File Convenience Methods
These forward unkown messages to my file, avoiding the inconvenience of needing to explicitly go through my reference object for every file operation
${example:Tempfile class>>#exampleFileOperation}$
!Future Research
For more inspiration in the future, we may explore *http://ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html*
"
Class {
	#name : #Tempfile,
	#superclass : #Object,
	#instVars : [
		'reference'
	],
	#category : #'Tempfile-Core'
}

{ #category : #accessing }
Tempfile class >> defaultFilename [
	^ DateAndTime now printString select: [ :c | c isAlphaNumeric or: [ '$-' includes: c ] ].
]

{ #category : #debugging }
Tempfile class >> deleteAll [
	self notify: 'This is primarily used for debugging, because my instances will delete their files when they are garbage collected, and doing if from the outside violates encapsulation and may wreak havoc in client code!'.
	self rootFolder deleteAllChildren
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

{ #category : #examples }
Tempfile class >> exampleDerivativeFile [
	<gtExample>
	| file |
	file := self exampleSimplestInstance / 'foo'.
	self assert: (file isKindOf: FileLocator).
	^ file
]

{ #category : #examples }
Tempfile class >> exampleFileOperation [
	<gtExample>
	"I respond to the full file reference API"
	self exampleSimplestInstance exists.
	
]

{ #category : #examples }
Tempfile class >> exampleGarbageCollectDeletesFile [
	<gtExample>
	| file reference |
	file := self exampleSimplestInstance.
	reference := file ensureCreateFile.
	
	file := nil.
	Smalltalk garbageCollect.
	
	self assert: reference exists not.
]

{ #category : #examples }
Tempfile class >> exampleSimplestInstance [
	<gtExample>
	"These ways are equivalent and are the easiest way to create an instance"
	| instances |
	instances := { FileLocator newTempfile. FileReference newTempfile. Tempfile new }.
	instances do: [ :tf | self assert: (tf isKindOf: Tempfile) ].
	^ instances atRandom
]

{ #category : #'instance creation' }
Tempfile class >> named: aString [
	^ self basicNew
		setReference: self rootFolder / aString;
		initialize;
		yourself
]

{ #category : #'instance creation' }
Tempfile class >> new [
	^ self withSuffix: ''
]

{ #category : #accessing }
Tempfile class >> rootFolder [
	^ FileLocator temp / 'pharo-tempfile'
]

{ #category : #'instance creation' }
Tempfile class >> withPrefix: aString [
	^ self named: aString, self defaultFilename.
]

{ #category : #'instance creation' }
Tempfile class >> withPrefix: prefixString andSuffix: suffixString [
	^ self named: prefixString, self defaultFilename, suffixString.
]

{ #category : #examples }
Tempfile class >> withPrefixAndSuffixExample [
	<gtExample>
	| file |
	file := self withPrefix: 'prefix' andSuffix: 'suffix'.
	self assert: (file base beginsWith: 'prefix').
	self assert: (file base endsWith: 'suffix').
	^ file
]

{ #category : #examples }
Tempfile class >> withPrefixExample [
	<gtExample>
	| file |
	file := self withPrefix: 'prefix'.
	self assert: (file base beginsWith: 'prefix').
	^ file
]

{ #category : #'instance creation' }
Tempfile class >> withSuffix: aString [
	"aString - suffix e.g. `-abc.txt`; could be/contain an extension, but doesn't have to"
	^ self named: self defaultFilename, aString.
]

{ #category : #examples }
Tempfile class >> withSuffixExample [
	<gtExample>
	| file |
	file := self withSuffix: 'Suffix'.
	self assert: (file base endsWith: 'Suffix').
	^ file
]

{ #category : #deleting }
Tempfile >> deleteAfter: aBlock [
	"This is only needed for speedier deletion because I will otherwise delete my file when I am garbage collected"
	[ aBlock value: self ]
		ensure: [ self reference exists ifTrue: [ self reference deleteAll ] ]
]

{ #category : #'reflective operations' }
Tempfile >> doesNotUnderstand: aMessage [
	^ (self reference respondsTo: aMessage selector)
		ifTrue: [ aMessage sendTo: self reference ]
		ifFalse: [ super doesNotUnderstand: aMessage ]
]

{ #category : #finalization }
Tempfile >> finalize [
	self reference exists ifTrue: [ self reference deleteAll ]
]

{ #category : #initialization }
Tempfile >> initialize [
	super initialize.
	WeakRegistry default add: self.
	
	self class rootFolder ensureCreateDirectory. "While this is not an instance responsibility per se, this seemed like the latest possible time to do this, with the minimum work (e.g. as opposed to sending on every access or creating on image startup), while still ensuring the folder is created before use (otherwise e.g. shell scripts may fail)"
]

{ #category : #accessing }
Tempfile >> printOn: aStream [

	self reference printOn: aStream.
	aStream nextPutAll: ' ('.
	super printOn: aStream.
	aStream nextPut: $).
]

{ #category : #accessing }
Tempfile >> reference [
	^ reference
]

{ #category : #private }
Tempfile >> setReference: aReference [
	"DANGER: Must not be used by client code. I am a value object. Otherwise, finalization will not delete the right underlying file!"
	reference := aReference
]
