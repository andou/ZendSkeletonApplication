class window.StoreList
	constructor :(@ref)->
		@list = @ref.find '#content #searchResult'
		event_emitter.addListener 'DATA_READY',@createList
		event_emitter.addListener 'REFRESH_STORES', @updateStores
	createList :(data)=>
		store_list = []
		for i in [0...data.length]
			store_is_new = if data[i]["new_store"] is "1" then "<div class='ico-new' data-icon='z'>" else ""
			is_odd = if i%2 is 0 then "odd" else ""
			store_list.push "<li class='item #{is_odd}' data-marker='#{i}'><a href='#' class='storeSummary'>#{store_is_new}</div>
				<h2 class='storeName'><span class='icon' data-icon='f'></span><span class='label'>#{data[i]['title']}</span></h2>
        <p class='storeAddress'>#{data[i]['address']}, #{data[i]['cap']}, #{data[i]['city']}, #{data[i]['country']}</p>
        <p class='storePhone'><span class='icon' data-icon='g'></span><span class='label'>#{data[i]['tel']}</span></p>
        <p class='storeDistance'>1.1km</p>
          </a>
        </li>"
		@list.html store_list.join ''
		if store_list_iscroll? then store_list_iscroll.refresh()
		@setInteractions()
		event_emitter.emitEvent "STORE_LIST_READY"

	updateStores:(num,is_active)=>
		@store_item = @list.find '>li' 
		for i in [0...@store_item.length]
			@store = $ @store_item[i]
			@data_marker = parseInt @store.attr 'data-marker'
			if @data_marker is parseInt num 
				if is_active then @store.show() else @store.hide()
		if store_list_iscroll? then store_list_iscroll.refresh()

	setInteractions:()=>
		@store_item = @list.find '>li' 
		@store_item.click (e)=>
			e.preventDefault()
			store_item = e.currentTarget
			num = $(store_item).attr 'data-marker'
			event_emitter.emitEvent 'STORE_ITEM_SELECTED',[num]
			event_emitter.emitEvent 'STORE_ADDRESS_CHANGED'
			if !window.desktop_size then event_emitter.emitEvent 'CLOSE_STORE_TAB'








              