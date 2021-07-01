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
			baseline: 'Mocketry' with: [
				spec repository: 'github://dionisiydk/Mocketry' ].
		spec package: 'Tempfile' with: [
				spec requires: #('Mocketry' ) ] ].

]
