class window.SliderMouseFollower

  constructor: (@ref, @start_id = "") ->

    @is_ie = $.browser.msie
    @is_mobile = if navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/Android/i) then true else false
    @is_android = if navigator.userAgent.match(/Android/i) then true else false

    @doc = $ document
    @w = $ window

    @holder = @ref.find '.thumb-list'
    @loaded = 0
    #@thumbs = @cloneThumbs()
    @thumbs = @holder.find '.thumb'
    @thumbs_array = @thumbs
    @current_thumb = null

    @fps = 30
    @w_width = 0
    @ref_height = @ref.height()
    @holder_width = 0
    @thumb_width = 0
    @target_vel_min = 2
    @target_vel_max = 30
    @vel_min = 0
    @vel_max = 0
    @dur = 1.2
    @is_mouse_over = false
    @is_updating = false

    @onResize()
    @setHolderWidth()
    unless @is_mobile then @w.resize @onResize

    if @is_mobile
      @holder.attr('data-scrollable', 'x')
      new EasyScroller @holder[0], {
        scrollingX: true,
        scrollingY: false,
        zooming: false
      }
    else
      @startUpdating()

    @updateThumbsById @start_id
    @setInteractions()
  ##############
  # INTERACTIONS
  ##############

  setInteractions: ->

    for i in [0...@thumbs.length]

      thumb = $ @thumbs[i]
      thumb_link = thumb.find '.thumb-link'

      if @is_mobile
        thumb_link.bind 'touchstart', @onThumbTouchStart
        thumb_link.bind 'touchend', @onThumbClick
      else
        thumb_link.bind 'click', @onThumbClick


  onThumbTouchStart: (e) =>

    if @is_android
      @touch = e.originalEvent.changedTouches[0]
    else
      @touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0]
    @touch_start = @touch.pageX

  onThumbClick: (e) =>

    e.preventDefault()

    if @is_mobile
      if @is_android then @touch = e.originalEvent.changedTouches[0]
      if Math.abs(@touch.pageX - @touch_start) > 0 then return

    thumb = $(e.currentTarget).parent()
    @triggerByThumb thumb

  triggerByThumb: (thumb) ->

    unless thumb.hasClass('disabled')

      id = thumb.attr 'data-id'
      @updateThumbsById id
      event_emitter.emitEvent 'THUMB_CLICK', [id]

  ################
  # UPDATE CURRENT
  ################

  updateThumbsById: (id) =>

    thumb = $ @thumbs[@getIndexById id]
    if @current_thumb? and thumb isnt @current_thumb
      @current_thumb.removeClass 'disabled'
      @current_thumb = null

    if @current_thumb is null
      @current_thumb = thumb
      @current_thumb.addClass 'disabled'

  ########
  # LAYOUT
  ########

  setWrapperWidth: ->

    @w_width = @ref.width()

  setHolderWidth: ->

    thumb = $ @thumbs[0]
    @thumb_width = parseInt(thumb.css 'width')
    @holder_width = @thumbs.length * @thumb_width
    @holder.css {width: "#{@holder_width}px"}

  ####################
  # SCROLLING / UPDATE
  ####################

  startUpdating: ->

    unless @is_mobile
      if @is_ie
        @doc.bind 'mousemove', @onMouseMove
      else
        @w.bind 'mousemove', @onMouseMove
      @is_updating = true
      @setUpdateTimeout()

  stopUpdating: ->

    unless @is_mobile
      if @is_ie
        @doc.unbind 'mousemove', @onMouseMove
      else
        @w.unbind 'mousemove'
      @is_updating = false

  onMouseMove: (e) =>

    if @is_ie
      @mouseX = e.clientX
      @mouseY = e.clientY
    else
      @mouseX = e.pageX
      @mouseY = e.pageY

  setUpdateTimeout: ->

    @update_timeout = window.setTimeout @updatePosition, 1000 / @fps

  clearUpdateTimeout: ->

    window.clearTimeout @update_timeout

  updatePosition: =>

    @clearUpdateTimeout()

    posX = 2 * (((@mouseX - (@w.width() - @w_width)) / @w_width) - .5)
    current_left = @holder.position().left
    current_amp = Math.max(0, parseInt(@holder_width - @w_width))
    current_vel = @vel_min + (1 - Math.abs(2 * ((Math.abs(current_left) / current_amp) - .5))) * @vel_max
    updated_left = current_left - posX * current_vel
    bounded_left = Math.max(- current_amp, Math.min(0, updated_left))

    @holder.css {left: bounded_left}

    if @is_updating then @setUpdateTimeout()

    scroll_offset = if @is_ie then @w.scrollTop() else 0
    if @ref.offset().top <= @mouseY + scroll_offset <= @ref.offset().top + @ref_height
      if !@is_mouse_over
        @is_mouse_over = true
        TweenLite.to @, @dur, {vel_min:@target_vel_min, ease:Power4.easeInOut}
        TweenLite.to @, @dur, {vel_max:@target_vel_max, ease:Power4.easeInOut}
    else
      if @is_mouse_over
        @is_mouse_over = false
        TweenLite.to @, @dur, {vel_min:0, ease:Power4.easeInOut}
        TweenLite.to @, @dur, {vel_max:0, ease:Power4.easeInOut}

  ########
  # RESIZE
  ########

  onResize: => @setWrapperWidth()

  #######
  # UTILS
  #######

  getIndexById: (id) ->

    index = 0

    for i in [0...@thumbs_array.length]
      el = $ @thumbs_array[i]
      _id = el.attr 'data-id'
      if _id is id
        index = i
        break

    return index

