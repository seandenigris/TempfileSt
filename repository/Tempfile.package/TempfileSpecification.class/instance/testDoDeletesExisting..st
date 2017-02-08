tests
testDoDeletesExisting: creationBlock
	| instance |
	Tempfile do: [ :tf | 
		instance := tf.
		tf exists should beFalse.
		creationBlock value: tf.
		tf exists should beTrue ].
	instance exists should beFalse.