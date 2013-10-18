class window.HeaderController
	constructor:(@header)->
		@is_mobile_version = false
		@header_navigation = @header.find '.navigation-bar'
		@concept_btn = @header_navigation.find 'a.store-concept'
		@store_concept = $ '.store-concept-preview'
		@store_concept_close_btn = @store_concept.find 'a.close'

		@setStoreConcept()


	setStoreConcept :()=>
		@right = - @store_concept.width()
		@store_concept.css 'right', @right
		@concept_btn.click (e)=>
			e.preventDefault()
			btn = $ e.currentTarget
			btn.toggleClass 'active'
			if btn.hasClass 'active'
				TweenLite.to @store_concept,.5, {css:{'right': 0},easing:Expo.easeOut}
			else
				TweenLite.to @store_concept,.3, {css:{'right':@right},easing:Expo.easeIn}

		@store_concept_close_btn.click (e)=>
			e.preventDefault()
			@concept_btn.click()

		@store_concept.swipe
			swipeRight:(event, direction, distance, duration, fingerCount)=>
				@concept_btn.click()