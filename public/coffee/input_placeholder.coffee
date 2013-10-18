class window.InputPlaceHolder 
	constructor :(@ref) ->
		@ref.live('focus', ((e) => @searchBoxFocus e)).live('blur', ((e) => @searchBoxBlur e))

	searchBoxFocus:(e) =>
		box = $ e.currentTarget
		box.val '' if box.val() is box.attr 'suggest'
	searchBoxBlur:(e) =>
		box = $ e.currentTarget
		box.val(box.attr 'suggest') if box.val() is ''