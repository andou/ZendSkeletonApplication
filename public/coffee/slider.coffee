class window.Slider
	constructor:(@ref)->
		@w = $ window
		@slider = @ref.find '.slider'
		@slide = @slider.find '.slide'
		@action_bar_ref = @ref.find '.wrap-controller'
		@wrapInfo = @ref.find '.wrapInfo'
		event_emitter.addListener 'THUMB_CLICK',@onThumbClick
		@view = "landscape"
		@currentId = 1
		if @action_bar_ref.length > 0
			@type = "complex"
			@initComplexSlider()
		if @wrapInfo.length > 0
			@type = "simple"
			@initSimpleSlider()

		@initSlides()
		event_emitter.emitEvent 'THUMB_CLICK',['01']
		@onResize()

	initSimpleSlider :()=>
		@paginator = @wrapInfo.find '.sliderPaginator li >a'
		for i in [0...@paginator.length]
			ball = $ @paginator[i]
			ball.click (e)=>
				e.preventDefault()
				bl = $ e.currentTarget
				@checkActive bl
				id = bl.parent().attr 'data-id'
				event_emitter.emitEvent 'THUMB_CLICK',[id]
			@checkActive $ @paginator[0]

	checkActive: (bl)=>
		for i in [0...@paginator.length]
			ball = $ @paginator[i]
			if ball isnt bl and ball.hasClass 'active' then ball.removeClass 'active'
		bl.addClass 'active'

	initComplexSlider:()=>
		@progress_bar_ref = @action_bar_ref.find '.progress-bar'
		@thumbs_ref = @ref.find '.wrap-thumbs'
		@thumblist = @thumbs_ref.find '.thumb-list'
		@thumblist.css 'left',0
		@data_array = @thumbs_ref.find '.thumb-list .thumb'
		@progress_bar_current_ref = @progress_bar_ref.find '.current'
		@slidermenu = new SliderMouseFollower @thumbs_ref
		@thumbsHide = @ref.find '.thumbsHide'
		@thumbsShow = @ref.find '.thumbsShow'
		@initThumbsControl()
		@setProgressBar()
		

	initThumbsControl:()=>
		@thumbsShow.hide()
		@thumbsShow.click (e)=>
			btn = $ e.currentTarget
			e.preventDefault()
			btn.hide()
			@thumbsHide.show()
			TweenLite.to @action_bar_ref,.5,{css:{'top':0},ease:Power3.easeOut}
		@thumbsHide.click (e)=>
			btn = $ e.currentTarget
			e.preventDefault()
			btn.hide()
			@thumbsShow.show()
			TweenLite.to @action_bar_ref,.3,{css:{'top':85},ease:Power4.easeIn}

	initSlides :()=>
		for i in [0...@slide.length]
			slide = $ @slide[i]
			img = slide.find 'img'
			src = img.attr 'src'
			slide.attr 'data-landscape',src
			TweenLite.to slide,.1, {css:{'opacity':0}, ease:Power4.easeInOut}

	# PROGRESS BAR

	setProgressBar: ->

		@updateProgressBar 0
		@resizeProgressBar

	updateProgressBar: (index) ->

		@progress_bar_current_ref.attr 'data-index', index
		w = index * @getProgressBarStep()
		TweenLite.to @progress_bar_current_ref, 1, {css:{'width':"#{w}px"}, ease:Power4.easeInOut}

	getProgressBarStep: =>
		progress_bar_step = (@thumbs_ref.width() / @data_array.length) 

	# RESIZE

	resizeProgressBar: =>

		w = (@progress_bar_current_ref.attr 'data-index') * @getProgressBarStep()
		@progress_bar_current_ref.css {width: "#{w}px"}


	onThumbClick: (id) =>
		#@slider.updateThumbsById id
		if @type is "complex" then @updateProgressBar id
		for i in [0...@slide.length]
			slide = $ @slide[i]

			_index = parseInt slide.attr 'data-id'
			_id = parseInt id
			_currentId = parseInt @currentId

			if _index is _id then nextSlide = slide
			if _index is _currentId then currentSlide = slide

		TweenLite.to currentSlide,.8, {css:{'opacity':0}, ease:Power4.easeInOut}
		TweenLite.to nextSlide,1, {css:{'opacity':1}, ease:Power4.easeInOut}
		@currentId = id

	checkIfImageIsOk :()=>
		if @view is "portrait"
			if @area_w > @area_h
				#console.log 'landcape is needed'
				@view = "landscape"
				@loadNewImages() 
		else 
			if @area_w < @area_h
				@view = "portrait"
				#console.log 'portrait is needed'
				@loadNewImages()
				

	loadNewImages :()=>
		for i in [0...@slide.length]
			background = $ @slide[i]
			img = background.find 'img'
			if @view is "portrait" then src = background.attr 'data-portrait' else src = background.attr 'data-landscape'
			img.attr 'src',src
			preloader = new Image()
			preloader.ref = img
			preloader.onload = @onImageLoaded
			preloader.src = src

	onImageLoaded:()=>
		@onResize()

	onResize :()=>
		if @type is "complex" then @resizeProgressBar()
		@area_w = @slider.width()
		@area_h = @slider.height()
		@checkIfImageIsOk()
		for i in [0...@slide.length]
			background = $ @slide[i]
			img = background.find 'img'
			ratio = parseFloat(img.width()/img.height())
			unless isNaN ratio
				h = @area_w / ratio
				if h > @area_h
					w = @area_w
					top = .5 * (@area_h - h)
					left = 0
				else
					w = @area_h * ratio
					h = @area_h
					top = 0
					left = .5 * (@area_w - w)

				background.css {width: "#{w}px", height: "#{h}px", top: "#{top}px", left: "#{left}px"}
				#background.css {width: "#{w}px", height: "#{h}px"}






		
