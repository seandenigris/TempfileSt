tests
testDoDeletesExistingDirectory

	self testDoDeletesExisting: [ :tf | 
		tf ensureCreateDirectory.
		(tf / 'file1.txt') ensureCreateFile ].