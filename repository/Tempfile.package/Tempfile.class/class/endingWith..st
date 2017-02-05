instance creation
endingWith: aString
	| filename |
	filename := DateAndTime now printString select: [ :c | c isAlphaNumeric or: [ #($-) includes: c ] ].
	^ FileLocator temp / filename, aString.