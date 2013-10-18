class window.ScrollBarHelper
	constructor:()->
		event_emitter.addListener 'SET_SCROLLBARS',@setscrollbars
	setscrollbars:()=>
		if !window.is_ie or window.is_ie and ie_version>8
			if $('#wrapSearchResult').length > 0 then window.store_list_iscroll = new iScroll 'wrapSearchResult', {scrollbarClass: 'myScrollbar'}
			if $('#auxFilterList').length > 0 then window.filter_list_iscroll = new iScroll 'auxFilterList', {scrollbarClass: 'myScrollbar'}
			if $('#direction-panel-scroller').length > 0 then window.direction_list_iscroll = new iScroll 'direction-panel-scroller', {scrollbarClass: 'myScrollbar'}
			if $('#mainContentWrapper').length > 0 then  window.content_store_iscroll = new iScroll 'mainContentWrapper', {scrollbarClass: 'myScrollbar'}
			document.addEventListener "touchmove", ((e) ->
				e.preventDefault()
			), false
	
