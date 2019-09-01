Class {
	#name : #BaselineOfTempfile,
	#superclass : #BaselineOf,
	#category : #BaselineOfTempfile
}

{ #category : #baseline }
BaselineOfTempfile >> baseline: spec [
  <baseline>

	spec for: #'common' do: [
		spec
			baseline: 'BabyPhexample' with: [
				spec repository: 'github://seandenigris/Baby-Phexample' ].
		spec package: 'Tempfile' ].

]
