instance creation
do: aBlock
	| instance |
	instance := self new.
	aBlock value: instance.
	instance exists ifTrue: [ instance deleteAll ]