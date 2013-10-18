unless window.console then window.console = {log: ((obj) ->)}

$ ->

	window_ref = $ window

	###################
	# USER AGENT CHECK#
	###################

	getInternetExplorerVersion = ->

		matches = new RegExp(" MSIE ([0-9].[0-9]);").exec(window.navigator.userAgent)
		version = if matches? and matches.length > 1 then parseInt(matches[1].replace(".0", "")) else -1
		return version

	getIOSVersion = ->
		if /iP(hone|od|ad)/.test(navigator.platform)
			v = (navigator.appVersion).match(/OS (\d+)_(\d+)_?(\d+)?/)
			return [parseInt(v[1], 10), parseInt(v[2], 10), parseInt(v[3] || 0, 10)]
		else
			return false


	window.ie_version = getInternetExplorerVersion()
	window.has_ios = getIOSVersion()

	window.is_ie = $.browser.msie
	window.is_ie6 = $.browser.msie and ie_version is 6
	window.is_ie7 = $.browser.msie and ie_version is 7
	window.is_ie8 = $.browser.msie and ie_version is 8
	window.is_ie9 = $.browser.msie and ie_version is 9
	window.is_ie10 = $.browser.msie and ie_version is 10
	window.is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1
	window.is_mobile = if navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/Android/i) then true else false
	window.is_iphone = if navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i) then true else false
	window.is_ipad = if navigator.userAgent.match(/iPad/i) then true else false
	window.is_android = if navigator.userAgent.match(/Android/i) then true else false

	#Normal layout =>720
	window.phone_break_point = 720
	window.item_min_height = 170

	if window_ref.width() >= window.phone_break_point then window.desktop_size = true else window.desktop_size = false

	################
	# EVENT EMITTER#
	################

	window.event_emitter = new EventEmitter()


	#########
	#SPLASH#
	#########
	splash = $ '.wrap-overlay .overlay .locateFail'
	if splash.length is 1 then new Splash splash

	######
	#TABS#
	######

	toolbar = $ '#toolbar'
	if toolbar.length is 1 and window.desktop_size then tabController = new TabController toolbar

	########
	#HEADER#
	########

	header = $ '#header'
	if header.length is 1 and window.desktop_size then headerController = new HeaderController header


	############
	#STORE LIST#
	############

	store_list = toolbar.find '.toolbar-content .stores-content'
	if store_list.length is 1 then new StoreList store_list


	###################
	#GETTING DIRECTION#
	###################
	direction_panel = toolbar.find '.toolbar-content .direction-content'
	if direction_panel.length is 1 then new GetDirection direction_panel

	#####
	#MAP#
	#####

	map_div = $ '#storemap'
	if map_div.length is 1 then gmap = new MapManager map_div
	google.maps.event.addDomListener window, 'load',()-> event_emitter.emitEvent "IS_READY"



	#############
	#FILTER LIST#
	#############

	filterList = $ '.filterList'
	if filterList.length is 1 then new FilterManager filterList

	###############
	#SCROLL BARS
	###############
	scrollbarhelper = new ScrollBarHelper

	#################
	# SOCIAL SHARING#
	#################

	sharing_modules = $ '.js-sharing'
	if sharing_modules.length > 0
		for i in [0...sharing_modules.length]
			unless $(sharing_modules[i]).hasClass 'link'
				new SocialSharing $(sharing_modules[i])

	########
	#INPUT#
	#######

	input_boxes = $ '.input-js'
	if input_boxes.length > 0
		for i in [0...input_boxes.length]
			new InputPlaceHolder input_boxes

	#########
	# SLIDER#
	#########

	slider_ref = $ '.sliderWrapper'
	window.sliders= []
	if slider_ref.length > 0 
		for i in [0...slider_ref.length]
			slider = new Slider $(slider_ref[i])
			window.sliders.push slider

	#################
	# ELEMENT RESIZE#
	#################

	element_to_resize = $ '.js-dynamic-height'
	window.elements= []
	if element_to_resize.length > 0
		for i in [0...element_to_resize.length]
			resized_element = new ResizeElement $(element_to_resize[i])
			window.elements.push resized_element


	################
	# INFO PAGE SLIDER
	################

	# slider_container = $ '.mainSlider'
	# if slider_container.length is 1 then  slider = new InfoSlider slider_container

	#############
	#FOURSQUARE#
	############
	(->
		window.___fourSq =
			explicit: false
			onReady: ->
				this_widget = $ ".fc-webicon.foursquare"
				widget = new fourSq.widget.SaveTo()
				widget.attach this_widget[0]

		s = document.createElement "script"
		s.type = "text/javascript"
		s.src = "http://platform.foursquare.com/js/widgets.js"
		s.async = true
		ph = document.getElementsByTagName("script")[0]
		ph.parentNode.insertBefore s, ph
	)()

	#################
	# GENERAL SCROLL#
	#################

	onWindowScroll = =>
		val = window_ref.scrollTop()
		# USAGE: if instance? then instance.onScroll val

	window_ref.scroll onWindowScroll

	#################
	# GENERAL RESIZE#
	#################

	onWindowResize = =>
		window_w = window_ref.width()
		window_h = window_ref.height()
		# USAGE: if instance? then instance.onResize window_w, window_h
		if window_w >= window.phone_break_point then window.desktop_size = true else window.desktop_size = false
		if gmap? then gmap.onResize window_w, window_h
		if tabController? then tabController.onResize window_w, window_h
		if store_list_iscroll? then store_list_iscroll.refresh()
		if filter_list_iscroll? then filter_list_iscroll.refresh()
		if direction_list_iscroll? then direction_list_iscroll.refresh()
		if elements.length > 0
			for i in [0...elements.length]
				window.elements[i].onResize window_w, window_h

		if sliders.length > 0 
			for i in [0...sliders.length]
				window.sliders[i].onResize window_w, window_h

		if slider? then slider.onResize()
		#####################################################
		#ADDING MOBILE CONTROLLER#
		#####################################################
		if !window.desktop_size and !mobileController? then window.mobileController = new MobileController header,toolbar
		if mobileController? then mobileController.onResize window_w, window_h


	window_ref.resize onWindowResize
	onWindowResize()

	event_emitter.addListener 'RESIZE_ALL',onWindowResize

##########
# ON LOAD#
##########

$(window).load(->
	window.event_emitter.emitEvent 'SET_SCROLLBARS'
	#event_emitter.emitEvent 'IS_LOADED'
)

