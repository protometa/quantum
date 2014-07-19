
assert = require 'assert'

quanta = require '../index.js'	

describe 'tests', ->
	it 'run', ->
		assert(true)

describe 'quanta', ->
	it 'exists', ->
		# console.log quanta
		assert quanta?
