class window.ResizeElement
	constructor:(@ref)->
		@header = $ '#header'
		@header_height = @header.height()


	onResize:(window_w,window_h)=>
		_height = window_h - @header_height
		@ref.css 'height',"#{_height}px"

