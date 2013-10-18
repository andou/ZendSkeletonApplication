class window.GetDirection
	constructor:(@ref)->
		@content = @ref.find '.direction'

		@travel_modes = @content.find '.travel-modes >li > a'

		@address_a = @content.find '.j-address_a'
		@address_b = @content.find '.j-address_b'

		@getDirection_btn = @ref.find '.action-bar >button'
		@traveling_mode = google.maps.DirectionsTravelMode.DRIVING

		@flipping_btn = @ref.find '.address-flip'
		@settingTravelingModes()

		@initGDBtn()
		@initFlipBtn()
		event_emitter.addListener 'DESTINATION_IS_CHANGED',@setDestination
		event_emitter.addListener 'BICYCLE_MODE_ISNT_AVAILABLE',@setwalking
		event_emitter.addListener 'SETTING_FOCUS',@settingFocus

		@content.find('.j-address_a').change ()=> @showAllTravelOptions()
		@content.find('.j-address_b').change ()=> @showAllTravelOptions()

		#@tmode_items
	initGDBtn :()=>
		@getDirection_btn.click (e)=>
			e.preventDefault()
			start = @content.find('.j-address_a').val()
			end = @content.find('.j-address_b').val()

			if start isnt '' and end isnt ''
				event_emitter.emitEvent "TAKE_DIRECTION",[start,end,@traveling_mode]

	initFlipBtn:()=>
		@flipping_btn.click (e)=>
			e.preventDefault()
			a_val = @address_a.val()
			b_val = @address_b.val()

			@old_a = @address_a
			@old_b = @address_b


			@address_a.val b_val
			@address_b.val a_val

			@address_a = @old_b
			@address_b = @old_a

			@getDirection_btn.click()

	setwalking :()=>
		for i in [0...@travel_modes.length]
			_tm = $ @travel_modes[i]
			if _tm.attr('data-travelingmode') is 'bicycling'
				_tm.addClass 'disabled'
			if _tm.attr('data-travelingmode') is 'walking'
				_tm.click()

	showAllTravelOptions :()=>
		console.log 'changed'
		for i in [0...@travel_modes.length]
			_tm = $ @travel_modes[i]
			_tm.removeClass 'disabled'

	settingTravelingModes :()=>

		for i in [0...@travel_modes.length]
			_tm = $ @travel_modes[i]
			_tm.click (e)=>
				e.preventDefault()
				tm = $ e.currentTarget
				@traveling_mode = @findTravelingMode tm.attr 'data-travelingmode'
				@setActive tm
				@getDirection_btn.click()

	settingFocus:(e)=>
		@address_a.trigger 'focus'
	setActive:(tm) =>
		for i in [0...@travel_modes.length]
			_tm = $ @travel_modes[i]
			if _tm isnt tm
				_tm.removeClass 'active'
		tm.addClass 'active'

	findTravelingMode:(mode)=>
		switch mode
			when 'driving' then  gmode = google.maps.DirectionsTravelMode.DRIVING
			when 'bicycling' then  gmode = google.maps.DirectionsTravelMode.BICYCLING
			when 'walking' then  gmode = google.maps.DirectionsTravelMode.WALKING
		return gmode

	setDestination :(address)=>
		@address_b.val address
