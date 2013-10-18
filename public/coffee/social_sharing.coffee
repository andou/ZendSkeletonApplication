class window.SocialSharing

	constructor: (@ref) ->

    @meta_title = ($ "meta[property='og:title']").attr 'content'
    @meta_image = ($ "meta[property='og:image']").attr 'content'
    @meta_description = ($ "meta[property='og:description']").attr 'content'
    @loc = (window.location.href).replace '#', ''

    @checkButtons()

  checkButtons: ->

    # FACEBOOK
    facebook_btn = @ref.find '.facebook a'
    if facebook_btn.length is 1
      facebook_url = encodeURI "http://www.facebook.com/sharer.php?u=#{@loc}"
      @setButton facebook_btn, facebook_url

    # TWITTER
    twitter_btn = @ref.find '.twitter a'
    if twitter_btn.length is 1
      twitter_url = encodeURI "http://twitter.com/share?text=#{@meta_title}&url=#{@loc}"
      @setButton twitter_btn, twitter_url

    # GPLUS
    gplus_btn = @ref.find '.gp a'
    if gplus_btn.length is 1
      gplus_url = encodeURI "https://plus.google.com/share?url=#{@loc}"
      @setButton gplus_btn, gplus_url

    # PINTEREST
    pinterest_btn = @ref.find '.pinterest a'
    if pinterest_btn.length is 1
      pinterest_url = encodeURI "http://pinterest.com/pin/create/button?url=#{@loc}&media=#{@meta_image}&description=#{@meta_description}"
      @setButton pinterest_btn, pinterest_url

    #email
    email_btn = @ref.find '.email a'
    if email_btn.length is 1
      email_subject = 'Ermenegildo Zegna'
      email_url = encodeURI "mailto:?subject=#{email_subject}&body=#{@loc}"
      # email_subject = email_btn.attr 'data-subject'
      # email_body = email_btn.attr 'data-body'
      # email_url = encodeURI "mailto:?subject=#{email_subject}&body=#{email_body}#{@loc}"
      @setButton email_btn, email_url, true

  setButton: (btn, url, is_email = false) =>

    btn.attr 'href', url
    unless is_email
      btn.bind 'click', ((e) ->
        e.preventDefault()
        window.open $(e.currentTarget).attr('href'), 'Share', 'toolbar=0,status=0,width=900,height=500')
