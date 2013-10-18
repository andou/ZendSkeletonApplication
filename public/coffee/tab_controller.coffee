class window.TabController
	constructor:(@ref)->

		@ref.hide()

		@header = @ref.parent().find '#header'
		@header_height = @header.height()

		@padding = 40
		@direction_top_height = 239

		@current_tab = "stores"

		@tab_bar = @ref.find '.toolbar-tabber'
		@stores_tab = @tab_bar.find '.js-stores_tab'
		@direction_tab = @tab_bar.find '.js-direction_tab'
		@general_content = @ref.find '.toolbar-content'
		@stores_content = @general_content.find '.stores-content'
		@search = @stores_content.find '.search-wrapper'
		@direction_content = @general_content.find '.direction-content'
		@direction_panel = @direction_content.find '#direction-panel-scroller'
		@filter_btn = @stores_content.find '.action-bar >a.filter'
		@stores_content_c = @stores_content.find '#content'
		@stores_content_searchResult = @stores_content.find '#content #wrapSearchResult'
		@stores_content_filterList = @stores_content.find '#content #wrapFilterList'
		@stores_content_auxFilterList = @stores_content.find '#content #auxFilterList'

		@footer_height = @filter_btn.height()
		@tab_height = @stores_tab.height()
		@search_height = parseInt @search.css 'height'
		@direction_display_btn_height = @direction_content.find('.action-bar >button').outerHeight()

		event_emitter.addListener 'CURRENT_TAB_IS_CHANGED',@tabChanged
		event_emitter.addListener 'STORE_LIST_READY',@showRef
		event_emitter.addListener 'OPEN_DIRECTION',@openDirection
		event_emitter.addListener 'DIRECTION_CHANGE_CALLBACK',@showDirections

		@direction_panel.hide()
		@setInteractions()
		@setFilterInteraction()
		@setHistory()


	showDirections:()=>
		@direction_panel.show()
		@ref.addClass 'direction-opened'

	showRef:()=>
		@ref.show()
		if store_list_iscroll? then store_list_iscroll.refresh()

	setInteractions:()=>
		@stores_tab.click (e) =>
			e.preventDefault()
			if @current_tab isnt "stores"
				stores_tab = $ e.currentTarget
				stores_tab.toggleClass 'current'
				@direction_tab.toggleClass 'current'
				@stores_content.show()
				@direction_content.hide()
				@current_tab = "stores"
				event_emitter.emitEvent "CURRENT_TAB_IS_CHANGED"
				if !@stores_history 
					History.pushState {state:@current_tab}, "Stores", "stores"
					@stores_history= true
				else
					History.replaceState {state: @current_tab}, "Stores", "stores"

		@direction_tab.click (e) =>
			e.preventDefault()
			if @current_tab isnt "directions"
				direction_tab =  $ e.currentTarget
				direction_tab.toggleClass 'current'
				@stores_tab.toggleClass 'current'
				@direction_content.show()
				@stores_content.hide()
				@current_tab = "directions"
				event_emitter.emitEvent "CURRENT_TAB_IS_CHANGED"
				if !@directions_history 
					History.pushState {state: @current_tab}, "Directions", "directions"
					@directions_history = true
				else
					History.replaceState {state: @current_tab}, "Directions", "directions"

	setFilterInteraction:()=>
		@filter_btn.click (e)=>
			filter_btn = $ e.currentTarget
			if @current_tab is "stores"
				filter_btn.toggleClass 'active'
				if !filter_btn.hasClass 'active'
					@stores_content_searchResult.hide()
					@stores_content_filterList.show()
					if filter_list_iscroll? then filter_list_iscroll.refresh()
				else
					@stores_content_searchResult.show()
					@stores_content_filterList.hide()
					if store_list_iscroll? then store_list_iscroll.refresh()

	openDirection :()=>
		@direction_tab.click()
		event_emitter.emitEvent 'SETTING_FOCUS'

	tabChanged:()=>
		if @current_tab isnt "stores"
			@direction_panel.hide()
			@stores_content_filterList.hide()
			@stores_content_searchResult.show()
			@filter_btn.addClass 'active'
			@ref.removeClass 'direction-opened'
			event_emitter.emitEvent 'SETTING_MAP_OPTIONS'
		else
			@direction_panel.hide()
			@ref.removeClass 'direction-opened'
			event_emitter.emitEvent 'CLEAR_DIRECTION'
			if store_list_iscroll? then store_list_iscroll.refresh()

	onResize : (window_w,window_h) =>
		height_to_assign = window_h - @header_height - @footer_height - @padding - @search_height - @tab_height
		direction_height_to_assign = window_h - @header_height - @direction_top_height - @direction_display_btn_height - @padding - @tab_height

		if height_to_assign < window.item_min_height then height_to_assign = window.item_min_height
		if direction_height_to_assign < window.item_min_height then direction_height_to_assign = window.item_min_height - 200

		max_height = @stores_content_filterList.find('.filterList').children('li').length * 92

		if height_to_assign > max_height then height_to_assign = max_height

		@stores_content_c.css 'height',"#{height_to_assign}px"
		@stores_content_searchResult.css 'height',"#{height_to_assign}px"
		@stores_content_filterList.css 'height',"#{height_to_assign}px"
		@stores_content_auxFilterList.css 'height',"#{height_to_assign}px"
		@direction_panel.css 'height',"#{direction_height_to_assign}px"

	setHistory: ->
		@checkHistory()
		if !History.enabled then return false
		@has_history = true
		History.Adapter.bind window, 'statechange', @onHistoryStateChange

	checkHistory :()=>
		state = History.getState()
		tab = state.data["state"]
		if tab is "directions"
			@direction_tab.click()
			@directions_history = true
		else if tab is "stores"
			@stores_tab.click()
			@stores_history = true
		else 
			History.pushState {state:@current_tab}, "Stores", "stores"
			@stores_history = true

	onHistoryStateChange: =>
		State = History.getState()
		#History.log "history log --> ", State.data, State.title, State.url
		















