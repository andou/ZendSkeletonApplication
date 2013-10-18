class window.Splash
	constructor:(@ref)->
		
		@searchBox = @ref.find('.js-search_input').get 0
		@submit_btn = @ref.find('.js-search_btn')
		event_emitter.addListener "GEO_LOCATION_FAILED",@geolocationFailed
		#@google_searchBox = new google.maps.places.SearchBox @searchBox

	geolocationFailed:()=>
		@ref.show()
		@ref.parent().parent().show()
		@submit_btn.bind 'click',(e)=>
			e.preventDefault()
			submit_btn = $ e.currentTarget
			submit_btn.unbind 'click'
			@ref.hide()
			@ref.parent().parent().hide()
			event_emitter.emitEvent "MAP_INIT"
			#CALL WEBSERVICE

		

