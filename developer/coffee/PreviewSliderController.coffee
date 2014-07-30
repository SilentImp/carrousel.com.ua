define [
    'jquery.scrollTo/jquery.scrollTo.min'
  ], (
    dummy1
  )->

  class PreviewSliderController
    
    constructor: (@widget)->

      if @widget.length == 0
        return

      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @wrapper = @widget.find(".photos")
      @items = @wrapper.find(".photo")

      @nav = @widget.find(".preview-nav")
      @next_button = @nav.find(".preview-next")
      @prev_button = @nav.find(".preview-prev")

      if @items.length < 2 
        @nav.fadeOut()
        return

      last = @wrapper.find('.photo:last-child').clone(true)
      first = @wrapper.find('.photo:first-child').clone(true)
      @wrapper.prepend last
      @wrapper.append first
      @wrapper.find('.photo:last-child').addClass 'cloned'
      @wrapper.find('.photo:first-child').addClass 'cloned'
      @wrapper.scrollTo @wrapper.find('.photo:eq(1)'), 0

      @current = $(@items[0])
      @time = 200

      @next_button.on @itype, @next
      @prev_button.on @itype, @prev


    scrollToScreen: =>
      @wrapper.find('.photo').removeClass 'selected'
      @current.addClass 'selected'
      @wrapper.scrollTo @current, @time
        

    next: (event)=>
      event.preventDefault()
      @current = @current.next()

      # if @current.length == 0
      #   @current = $(@items[0])

      if  @current.hasClass('cloned')
        first = @wrapper.find(".photo:first-child")
        @wrapper.scrollTo first, 0
        @current = first.next()

      @scrollToScreen()
      
    
    prev: (event)=>
      event.preventDefault()
      @current = @current.prev()
      # if @current.length == 0
      #   @current = $(@items[@items.length-1])

      if  @current.hasClass('cloned')
        last = @wrapper.find(".photo:last-child")
        @wrapper.scrollTo last, 0
        @current = last.prev()

      @scrollToScreen()
      

  return PreviewSliderController