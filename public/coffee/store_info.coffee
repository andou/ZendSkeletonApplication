class window.InfoSlider
	constructor :(@ref) ->
		#slideContainer = $ '.mainSlider'
		@slide = $ 'li.slide img'
		@slideParent = $ 'li.slide'
		@sliderWrap = $ '.innerSlider'
		@sliderMenuWrap = $ '.sliderMenu'
		@sliderMenu = $ '.sliderMenuNav'
		@sliderMenuItem = $ '.sliderMenuNav li'
		# @infoWrap = $ '.storeInfoOuterWrap, .storeInfoWrap, .sidebar, .storeInfoSlider'
		@infoWrap_ct = $ '#mainContentWrapper'
		@infoWrap_sl = $ '.mainSlider'
		@header = $ '#header'
		# @header_h = @header.height()
		@slideCount = @slide.length
		@slideMenuCount = @sliderMenuItem.length
		@totalWidth = 0
		@totalWidth_m = 0
		@activeSlide = 0
		@containerWidth = @ref.width()
		@sliderMenuSet @ref.width(),@sliderMenuItem.length
		@sliderSetUp()
		@sliderInteraction()

	sliderMenuSet : (width,items) =>
		if items > 4
			@itemWidth = width / 4
		else if @itemsWidth is width / items-1
			@sliderMenuItem.children("img").css "width","#{@itemWidth}px"

	sliderSetUp : () =>
		for i in [0...@slideMenuCount]
		 calWidth = @sliderMenuItem.eq(i).width()
		 @totalWidth_m += calWidth
		@sliderMenu.css "width","#{@totalWidth_m}px"
		for i in [0...@slideCount]
			calWidth = @slide.eq(i).width()
			@slideParent.eq(i).width(calWidth)
			@totalWidth += calWidth
			if i is 0
				@slideParent.eq(i).css {'position':'absolute', 'opacity':'1', 'top' : '0px', 'z-index': i}
			else
				@slideParent.eq(i).css {'position':'absolute', 'opacity':'0', 'top' : '0px', 'z-index': i}
		@sliderWrap.css {'width' : @totalWidth, 'position' : 'relative'}
		@sliderMenuWrap.css {'z-index' : '9'}


	#Monitor Click of each slide menu
	sliderInteraction : () =>
		@sliderMenuItem.click (e) =>
			e.preventDefault()
			currentClick = $ e.currentTarget
			currentClickIndex = currentClick.index()
			@slideChange currentClickIndex
			currentClick.addClass 'active'

		@sliderMenu.mousemove (e) =>
			parentOffset = @sliderMenu.parent().offset()
			relX = e.pageX - parentOffset.left #calculate  mouse location from left corrner of Menu
			relY = e.pageY - parentOffset.top #calculate mouse location from top of menu
			if relX < 200
				TweenLite.killTweensOf @sliderMenu
				TweenLite.to @sliderMenu, 3, {css:{'margin-left': 0},easing:SlowMo.ease}
			if relX > @containerWidth - 200
				TweenLite.killTweensOf @sliderMenu
				TweenLite.to @sliderMenu, 3, {css:{'margin-left': @containerWidth - @totalWidth_m + 110},easing:SlowMo.ease}
	#When Mouse leaves the menu region stop all animations
		@sliderMenu.mouseleave () =>
			TweenLite.killTweensOf @sliderMenu



	slideChange : (showID) =>
		if showID isnt @activeSlide
			currentSlide = @slide.eq(@activeSlide).parent 'li'
			targetSlide = @slide.eq(showID).parent 'li'
			currentThumb = @sliderMenuItem.eq @activeSlide
			targetThumb = @sliderMenuItem.eq showID
			TweenLite.to currentSlide, 0.5, {css:{'opacity': '0'},easing:Sine.EaseIn}
			TweenLite.to targetSlide, 1, {css:{'opacity': '1'},easing:Sine.EaseIn}
			currentThumb.removeClass 'active'
			targetThumb.addClass 'active'
			@activeSlide = showID

	onResize:(window_w,window_h)=>
		@header_h = @header.height()
		if window_w > 720
			if @infoWrap? then @infoWrap.css "height","#{window_h - @header_h}px"
			if @infoWrap_ct? then @infoWrap_ct.css "height","#{window_h - @header_h}px"
			if @infoWrap_sl? then @infoWrap_sl.css "height","#{window_h - @header_h - 100}px"
		else
			@infoOutWrap = $ '.storeInfoOuterWrap'
			# if @infoOutWrap? then @infoOutWrap.css "height","#{window_h + 200}px"
