class window.MobileController
	constructor:(@header,@ref= null)->
		@body = $ 'body'
		@mobile_toolbar = @header.find '.action-bar-mobile'
		@store_mobile_btn = @mobile_toolbar.find 'a.store'
		@map_mobile_btn = @mobile_toolbar.find 'a.map'
		#@filter_mobile_btn = @mobile_toolbar.find 'a.filter'
		@header_open_btn = @header.find '.btn-menu'
		@has_toolbar = if @ref.length is 1 then true else false
		@header_height = @header.height()

		if @has_toolbar
			@general_content = @ref.find '.toolbar-content'
			@stores_content = @general_content.find '.stores-content'
			@filter_close_btn = @stores_content.find '.close-filter'
			@stores_content_c = @stores_content.find '#content'
			@stores_content_searchResult = @stores_content.find '#content #wrapSearchResult'
			@stores_content_filterList = @stores_content.find '#content #wrapFilterList'
			@search = @stores_content.find '.search-wrapper'
			@search_height = parseInt @search.css 'height'
			@stores_content_filterList.show()
			@stores_content.show()
			@setMobileInteractions()

		@setHeaderInteraction()
		event_emitter.addListener 'CLOSE_STORE_TAB',@closeStoreTab

	setHeaderInteraction :()=>
		@header_open_btn.click (e)=>
			e.preventDefault()
			@body.toggleClass 'menu-opened'
			event_emitter.emitEvent 'RESIZE_ALL'
			if @has_toolbar
				store_is_open = @stores_content_searchResult.hasClass 'open'
				filter_is_open = @stores_content_filterList.hasClass 'open'
				if store_is_open or filter_is_open
					@manual_menu = true
				else
					@manual_menu = false

	setMobileInteractions :()=>
		@map_mobile_btn.click (e)=>
			e.preventDefault()
			map_mobile_btn = $ e.currentTarget
			map_mobile_btn.addClass 'active'
			@closeStore()

		@store_mobile_btn.click (e)=>
			e.preventDefault()
			@openStore()
					
					# if @stores_content_filterList.hasClass 'open' then @stores_content_filterList.removeClass 'open'
					# if @filter_close_btn.hasClass 'open' then @filter_close_btn.removeClass 'open'
					# if @filter_mobile_btn.hasClass 'active' then @filter_mobile_btn.removeClass 'active'

		# @filter_mobile_btn.click (e)=>
		# 	filter_mobile_btn = $ e.currentTarget
		# 	e.preventDefault()
		# 	filter_mobile_btn.toggleClass 'active'
		# 	@stores_content_c.show "fast",()=>
  #      	@ref.addClass 'open-content'
  #      	body_has_menu = @body.hasClass 'menu-opened'
  #      	@stores_content_filterList.toggleClass 'open'
  #      	@filter_close_btn.toggleClass 'open'
  #      	if body_has_menu and !@manual_menu then @ body.removeClass 'menu-opened' else @manual_menu = false
		# 		if filter_list_iscroll? then filter_list_iscroll.refresh()
		# 		if @stores_content_searchResult.hasClass 'open' then @stores_content_searchResult.removeClass 'open'
		# 		if @store_mobile_btn.hasClass 'active' then @store_mobile_btn.removeClass 'active'

		# @filter_close_btn.click (e)=>
		# 	e.preventDefault()
		# 	@filter_mobile_btn.click()

		@stores_content_searchResult.get(0).addEventListener 'webkitTransitionEnd', ((e)=>
			e.stopPropagation()
			_stores_content_searchResult = $ e.currentTarget
			store_is_open = _stores_content_searchResult.hasClass 'open'
			if !store_is_open
				@ref.removeClass 'open-content'
		),false

		# @stores_content_filterList.get(0).addEventListener 'webkitTransitionEnd',((e)=>
		# 	e.stopPropagation()
		# 	_stores_content_filterList = $ e.currentTarget
		# 	store_is_open = @stores_content_searchResult.hasClass 'open'
		# 	filter_is_open = _stores_content_filterList.hasClass 'open'
		# 	if !store_is_open and !filter_is_open
		# 		@ref.removeClass 'open-content'
		# ),false

	closeStore:()=>
		@store_mobile_btn.removeClass 'active'
				
		@stores_content_c.show "fast",()=>
			@ref.addClass 'open-content'
			body_has_menu = @body.hasClass 'menu-opened'
			@stores_content_searchResult.removeClass 'open'

			if body_has_menu and !@manual_menu then @body.removeClass 'menu-opened' else @manual_menu = false
			if store_list_iscroll? then store_list_iscroll.refresh()
					

	openStore:()=>
		@store_mobile_btn.addClass 'active'
		@stores_content_c.show "fast",()=>
			@ref.addClass 'open-content'
			body_has_menu = @body.hasClass 'menu-opened'
			@stores_content_searchResult.addClass 'open'
			if @map_mobile_btn.hasClass 'active' then @map_mobile_btn.removeClass 'active'
			
			if body_has_menu and !@manual_menu then @body.removeClass 'menu-opened' else @manual_menu = false
			if store_list_iscroll? then store_list_iscroll.refresh()
			

	closeStoreTab :()=>
		@map_mobile_btn.click()

	onResize : (window_w,window_h) =>
		if @has_toolbar
			height_to_assign = window_h - @header_height - @search_height
			@stores_content_c.css 'height',"#{height_to_assign}px"
			@stores_content_searchResult.css 'height',"#{height_to_assign}px"
			@stores_content_filterList.css 'height',"#{height_to_assign}px"




