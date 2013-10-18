class window.FilterManager
	constructor:(@ref)->
		@filter = @ref.find 'li > a'
		@all = @findSelectAll()
		@all.addClass 'active'
		
		@initAllOption()
		@setInteractions()
		event_emitter.addListener 'CHECK_ALL_OPTION',@checkAllOption

	setInteractions :()=>
		@filter.click (e)->
			e.preventDefault()
			tocheck = $ e.currentTarget
			brand = tocheck.data 'brand'
			tocheck.toggleClass 'active'
			event_emitter.emitEvent 'BRAND_CHANGE',[brand,tocheck.hasClass 'active']

	findSelectAll:()=>
		_toreturn = ''
		@filter.each ()->
			attr_data = $(@).attr 'data-brand'
			if attr_data is 'all'
				_toreturn = $ @
		return _toreturn


	initAllOption :()=>
		@all.click (e) =>
			e.preventDefault()
			tocheck = $ e.currentTarget
			@clearAllChecked()
			if !tocheck.hasClass 'active'
				tocheck.toggleClass 'active'
				event_emitter.emitEvent 'SHOW_ALL_MARKERS'

	clearAllChecked :()=>
		@filter.each ()->
			attr_data = $(@).attr 'data-brand'
			if attr_data isnt 'all'
				$(@).removeClass 'active'

	checkAllOption:(length)=>
		if length isnt 0 and @all.hasClass 'active'
			@all.removeClass 'active'
		else if length is 0
			@all.addClass 'active'


