class window.MapManager
	constructor :(@ref) ->
		@map_container = @ref.get 0
		@def_long = -84.575195
		@def_lat= 44.139497
		@icon = "/public/images/marker.png"
		@iconA = "/public/images/marker_a.png"
		@iconB = "/public/images/marker_b.png"
		@data_url = "/public/json/map.json"
		@markers =[]
		@active_brands =[]
		if !window.desktop_size then @ref.data 'baloon',280
		@infobox_width = @ref.data 'baloon'
		@offset = 4
		@infoBox_pos_X = -(@infobox_width/2) + @offset
		@infoBox_pos_Y = -24
		@rendererOptions =
			suppressMarkers : true
		@directionsService = new google.maps.DirectionsService()
		@directionsDisplay = new google.maps.DirectionsRenderer(@rendererOptions)
		#@directionsDisplay.suppressMarkers = true

		@directionsDisplay.setPanel document.getElementById 'directions-panel'

		#@infobox = $ '.infowindow'
		@boxText = ''
		$('body').append @boxText
		@infobox_options=
			content: @boxText
			disableAutoPan: false
			maxWidth: 0
			pixelOffset: new google.maps.Size @infoBox_pos_X, @infoBox_pos_Y
			zIndex: null
			boxStyle:
			  background: ""
			  opacity: 1
			  width: "auto"
			closeBoxMargin: "0"
			closeBoxURL: ""
			infoBoxClearance: new google.maps.Size 1, 1
			isHidden: false
			pane: "floatPane"
			enableEventPropagation: false
			alignBottom:true

		@geolocation_options =
  		enableHighAccuracy: true
  		timeout: 1000
  		maximumAge: 0


		event_emitter.addListener "IS_READY", @findPosition
		event_emitter.addListener "BRAND_CHANGE", @checkActiveBrands
		event_emitter.addListener "SHOW_ALL_MARKERS", @showAllMarkers
		event_emitter.addListener "STORE_ITEM_SELECTED", @openMarker
		event_emitter.addListener "TAKE_DIRECTION", @showDirection
		event_emitter.addListener "MAP_INIT",@initialize
		event_emitter.addListener "CLEAR_DIRECTION",@cleanMap
		event_emitter.addListener "SETTING_MAP_OPTIONS",@settingMapOptions

		@setMapIntro()

	setMapIntro :()=>
		if window.desktop_size then @has_control = true else @has_control = false
		@map_options =
		  zoom: 10
		  center: new google.maps.LatLng( @def_lat,@def_long)
		  mapTypeId: google.maps.MapTypeId.ROADMAP
		  mapTypeControl: false

		  panControl: @has_control
		  panControlOptions:
		    position: google.maps.ControlPosition.TOP_RIGHT

		  zoomControl: @has_control
		  zoomControlOptions:
		    style: google.maps.ZoomControlStyle.LARGE
		    position: google.maps.ControlPosition.TOP_RIGHT

		  scaleControl: @has_control
		  scaleControlOptions:
		    position: google.maps.ControlPosition.TOP_RIGHT

		  streetViewControl: @has_control
		  streetViewControlOptions:
		    position: google.maps.ControlPosition.TOP_RIGHT

  	@map = new google.maps.Map @map_container, @map_options
  	@directionsDisplay.setMap @map

	initialize :(lat = @def_lat,long = @def_long) =>
		newLatLng = new google.maps.LatLng lat,long
		@map.setCenter newLatLng
		@loadData()
		if window.is_mobile
			@GeoMarker = new GeolocationMarker @map

		google.maps.event.addListener @directionsDisplay, 'directions_changed', ()=>
			event_emitter.emitEvent 'DIRECTION_CHANGE_CALLBACK'
			@timeout = setTimeout ()=>
				if direction_list_iscroll?
					direction_list_iscroll.refresh()
					direction_list_iscroll.scrollTo 0,0,0
				clearTimeout @timeout
			,1

	loadData : =>
		$.getJSON @data_url, @onDataLoaded

	onDataLoaded : (data)=>
		for i in [0...data.markers.marker.length]
			marker = {}
			$.each data.markers.marker[i],(key,val)=>
				marker[key] = val
			@markers.push marker

		@setMarkers()
		event_emitter.emitEvent 'DATA_READY',[@markers]

	setMarkers : =>
		for i in[0...@markers.length]
			brands_obj = @markers[i]["brands"]
			marker_on_map = new google.maps.Marker
				position: new google.maps.LatLng @markers[i]["latitude"], @markers[i]["longitude"]
				map: @map
				icon: new google.maps.MarkerImage @icon,null,null,null,new google.maps.Size(25, 36)
				animation: google.maps.Animation.DROP
			@markers[i]["marker_point"] = marker_on_map
			@markers[i]["visible"] = true
			google.maps.event.addListener marker_on_map, 'visible_changed', ()->
  			#console.log 'visible_changed triggered'

		@setInfoWindow()


	setInfoWindow : =>
		findContent = @findContent
		setAddress = @setAddress
		setInfoWindowInteractions = @setInfoWindowInteractions
		@ib = new InfoBox @infobox_options
		google.maps.event.addListener @ib, 'domready',@setInfoWindowInteractions
		ib = @ib
		for i in [0...@markers.length]
			google.maps.event.addListener @markers[i]["marker_point"], 'click', ()->
				ib.setContent findContent @
				ib.open @map,@
				event_emitter.emitEvent "DESTINATION_IS_CHANGED",[setAddress @]

		if !window.desktop_size
			google.maps.event.addListener @map, 'click', ()=>
    		@ib.close()

	setInfoWindowInteractions:()=>
		infobox = $ '.infowindow'
		close_btn = infobox.find '.close'
		direction_btn = infobox.find '.direction'
		close_btn.click (e)=>
			e.preventDefault()
			@ib.close()
		direction_btn.click (e)=>
			e.preventDefault()
			if window.desktop_size
				event_emitter.emitEvent 'OPEN_DIRECTION'
			else
				#open link
				console.log 'should open the link'

	findContent :(markerPoint)=>
		for i in [0...@markers.length]
			if @markers[i]["marker_point"] is markerPoint
				return "<div class='infowindow'>
				  <div class='content'>
            <a href='#' class='close' data-icon='c'></a>
				    <div class='store-summary'>
				      <div class='wrap-top-info'>
                <div class='top-info'>
                  <div class='ico-new' data-icon='z'></div>
                  <h2 class='storeName'><span class='label'>#{@markers[i]['title']}</span></h2>
                  <p class='storeAddress'>#{@markers[i]['address']}, #{@markers[i]['cap']},#{@markers[i]['city']},#{@markers[i]['country']}</p>
                  <span class='storeDistance'>0.km</span>
                </div>
              </div>
				      <div class='bottom-info'>
				        <div class='col-left'>
				          <p class='storeOpeningHours'><span class='title'>Today Opening Hours: </span> <span class='hours'>#{@markers[i]['opening_hours']}</span></p>
				          <p class='storePhone'><span class='label'>#{@markers[i]['tel']}</span></p>
				        </div>
				        <div class='col-right'>
				          <ul class='action'>
                    <li><a href='/storeinfo' class='icon info' data-icon='d'></a></li>
				            <li><a href='#' class='icon direction' data-icon='a'></a></li>
				          </ul>
				        </div>
				      </div>
				    </div>
				  </div>
				  <div class='footer'></div>
				</div>"
	setAddress :(markerPoint)=>
		for i in [0...@markers.length]
			if @markers[i]["marker_point"] is markerPoint
				return "#{@markers[i]['address']}, #{@markers[i]['cap']},#{@markers[i]['city']},#{@markers[i]['country']}"

	findPosition : =>
		if navigator.geolocation
			navigator.geolocation.getCurrentPosition @geolocationSuccess, @geolocationError, @geolocation_options
		else
			#@initialize()
			event_emitter.emitEvent "GEO_LOCATION_FAILED"


	geolocationSuccess: (position) =>
		@initialize position.coords.latitude,position.coords.longitude

	geolocationError: (Error) =>
		event_emitter.emitEvent "GEO_LOCATION_FAILED"


	onResize : (window_w,window_h) =>
		_h_ = window_h - parseInt $("#header").css 'height'
		if window_w < window.phone_break_point
			_h_ = _h_- 44
		@ref.css "width","#{window_w}px"
		@ref.css "height","#{_h_}px"
		if @map
			center = @map.getCenter()
			google.maps.event.trigger @map,'resize'
			@map.setCenter(center)

	checkBrands : () =>
		for i in [0...@markers.length]
			if @active_brands.length isnt 0
				_is_selected_brand = false
				for j in [0...@markers[i]["brands"].brand.length]
					brand_to_check = @markers[i]["brands"].brand[j]
					if $.inArray(brand_to_check,@active_brands) != -1
						_is_selected_brand = true
						break
					else
						_is_selected_brand = false

				if @markers[i]["visible"] isnt _is_selected_brand then @markers[i]["marker_point"].setVisible _is_selected_brand
				@markers[i]["visible"] = _is_selected_brand
				event_emitter.emitEvent 'REFRESH_STORES',[i,_is_selected_brand]
			else
				if @markers[i]["visible"] isnt true
					@markers[i]["marker_point"].setVisible true
					@markers[i]["visible"] = true
					event_emitter.emitEvent 'REFRESH_STORES',[i,true]

	checkActiveBrands :(brand,is_active)=>
		if is_active
			@active_brands.push brand
		else
			@popItem brand,@active_brands

		event_emitter.emitEvent 'CHECK_ALL_OPTION',[@active_brands.length]
		@checkBrands()

	popItem: (item,array) =>
		array.splice $.inArray(item,array), 1

	showAllMarkers :()=>
		@active_brands = []
		@checkBrands()

	hideAllMarkers :()=>
		for i in [0...@markers.length]
			@markers[i]["marker_point"].setVisible false
			@markers[i]["visible"] = false


	openMarker :(num)=>
		google.maps.event.trigger @markers[num]["marker_point"],'click'

	showDirection:(start,end,travelmode)=>


		request =
			origin:start
			destination:end
			travelMode:travelmode

		@directionsService.route request,(response, status) =>
			if status is google.maps.DirectionsStatus.ZERO_RESULTS & travelmode is google.maps.DirectionsTravelMode.BICYCLING
				event_emitter.emitEvent 'BICYCLE_MODE_ISNT_AVAILABLE'

			if status is google.maps.DirectionsStatus.OK
				@directionsDisplay.setDirections response
				@route = response.routes[0].legs[0]
				@startpoint = @route.steps[0].start_point
				@endpoint = @route.steps[@route.steps.length-1].end_point
				@startMarker = new google.maps.Marker
					position: @startpoint
					map: @map
					icon: @iconA
				@stopMarker = new google.maps.Marker
					position: @endpoint
					map: @map
					icon: @iconB
				@hideAllMarkers()
				@ib.close()

	cleanMap:()=>
		#@directionsDisplay.setMap null
		@directionsDisplay.setDirections routes: []
		if @startMarker? then @startMarker.setMap(null)
		if @stopMarker? then @stopMarker.setMap(null)
		@showAllMarkers()
		@map.setZoom @zoom
		@map.setCenter @pos

	settingMapOptions :()=>
		@zoom = @map.getZoom()
		@pos = @map.getCenter()







