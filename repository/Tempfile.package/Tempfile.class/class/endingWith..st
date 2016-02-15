instance creation
endingWith: aString
	| tempFolder basename |
	tempFolder := self imageDirectory / 'tmp'.
	tempFolder ensureCreateDirectory.
	basename := DateAndTime now printString asLegalSelector, aString.
	^ tempFolder / basename.