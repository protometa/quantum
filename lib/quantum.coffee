
require 'obj-uber'
q = require 'q'
uuid = require 'uuid'

Quantum = (data) ->
	id = new ArrayBuffer(16)
	@uber(data).uber
		_root: @
		_parent: null
		_id: uuid.v1 null, id

	for i, link of @_links
		link._parent = @
		link._root = @_root
		@_links[i] = new Quantum link

	if typeof _target is 'object'
		@_target._root = @_root
		@_target._parent = @_parent
		@_target._parentLink = @
		if !( @_target instanceof Quantum )
			@_target = new Quantum @_target


Quantum.prototype = 

	value: (set) ->
		if set? then @_value = set
		return @_value


	label: (set) ->
		if set? then @_label = set
		return @_label


	links: (test) ->

		testFn = switch 
			when typeof test is 'undefined'
				-> true
			when typeof test is 'string'
				-> @_label is testProp
			else
				test
	
		matches = []
		
		for i, link of @_links
			if testFn.call link
				matches.push link
			
		return matches


	children: (test) ->
		
		testFn = switch 
			when typeof test is 'undefined'
				-> true
			when typeof test is 'string'
				-> @_parentLink?._label is test
			else
				test

		matches = []
		
		for i, link of @_links
			if link._target instanceof Quantum and testFn.call link._target
				matches.push link._target
				
		return matches		


	descendants: (test) ->

		testFn = switch
			when typeof test is 'undefined'
				-> true
			when typeof test is 'string'
				-> @_parentLink?._label is test
			else
				test
				
		matches = []
		
		for i, link of @_links
			if link._target instanceof Quantum 
				if testFn.call link._target
					matches.push link._target
				matches = matches.concat link._target.descendants testFn
				
		return matches


	ancestors: (test) ->
		
		testFn = switch 
			when typeof test is 'undefined'
				-> true
			when typeof test is 'string'
				-> @_parentLink?._label is test
			else
				test
		
		matches = []
		
		if @_parent instanceof Quantum
			if testFn.call @_parent
				matches.push @_parent
			matches = matches.concat @_parent.ancestors testFn
		
		return matches


	ancestorLinks: (test) ->
		
		testFn = switch 
			when typeof test is 'undefined'
				-> true
			when typeof test is 'string'
				-> @_label is test
			else
				test
		
		matches = []
		
		if @_parentLink instanceof Quantum
			if testFn.call @_parentLink
				matches.push @_parentLink
			if @_parent instanceof Quantum
				matches = matches.concat @_parent.ancestorLinks testFn
		
		return matches


	quanta: (test) ->
		
		testFn = switch 
			when typeof test is 'undefined'
				-> true
			when typeof test is 'string'
				-> @_parentLink?._label is test
			when test instanceof ArrayBuffer
				-> idEquals @_id, test
			else
				test
				
		matches = []
		
		for i, link of @_links
			if testFn.call link
				matches.push link
			if link._target instanceof Quantum
				if testFn.call link._target
					matches.push link._target
				matches = matches.concat link._target.quanta testFn
				
		return matches


	findByID: (id) ->
		
		for link in @_links
			if idEquals @_id, id
				return link
			if link._target instanceof Quantum
				if idEquals link._target._id, id
					return link._target
				result = link._target.findByID( id )
				if result?
					return result
		
		#console.log 'id not found'
		return null


idEquals = (a,b) ->
	for i in [0...15]
		if a[i] isnt b[i]
			return false
	return true



module.exports = Quantum






