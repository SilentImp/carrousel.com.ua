define [
    'jquery.scrollTo/jquery.scrollTo.min'
  ], (
    dummy1
  )->

  class ItemSliderController
    
    constructor: (@widget)->

      if @widget.length == 0
        return

      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @wrapper = @widget.find(".item-slider-wrapper")
      @items = @wrapper.find(".item")

      @card = $("body>header>nav .card b")
      @items.find(".buy").on @itype, @addToCard
      
      @nav = @widget.find(".slider-navigation")
      @next_button = @nav.find(".slider-navigation-next")
      @prev_button = @nav.find(".slider-navigation-prev")
      
      @current = 0
      @time = 600

      @init_slider()      

      @next_button.on @itype, @next
      @prev_button.on @itype, @prev
      
      @reinit_timer = null
      $(window).on 'resize', @reinit

    addToCard: (event)=>
      event.preventDefault()
      count = @card.text()
      count = count.substr 1, count.length-2
      count = parseInt count, 10
      
      if isNaN(count)
        count = 0
      count++
      @card.text "("+count+")"

    reinit: =>
      if @reinit_timer != null
        window.clearTimeout @reinit_timer
      @reinit_timer = window.setTimeout @init_slider, 250

    init_slider: =>
      @screen_width = @wrapper.width()
      @onscreen = Math.floor @screen_width/300
      @screens = Math.ceil @items.length/@onscreen
      @time = @onscreen*300

      @wrapper.find('.cloned').remove()
      pre = []
      post = []
      
      for i in [0...@onscreen]
        pre.push $(@items[i]).clone(true)

      for i in [0...@onscreen]
        post.push $(@items[@items.length-@onscreen+i]).clone(true)

      for i in [0...@onscreen]
        @wrapper.append pre[i]
        @wrapper.find('.item:last-child').addClass("cloned")

      for i in [0...@onscreen]
        @wrapper.prepend post[i]
        @wrapper.find('.item:first-child').addClass("cloned")

      @wrapper.scrollTo @wrapper.find('.item:eq('+@onscreen+')'), 0

      if @current>=@screens
        @current=@screens-1

      if @onscreen>=@items.length
        @nav.fadeOut()
      else
        @nav.fadeIn()

      @current = 0
      @scrollToScreen()


    scrollToScreen: =>
      @wrapper.scrollTo {top:0, left:@current*(@screen_width+50)+(@screen_width+50)}, @time

    next: (event)=>
      event.preventDefault()
      @current++

      if @current>@screens
        @wrapper.scrollTo @wrapper.find('.item:eq('+@onscreen+')'), 0
        @current = 1

      @scrollToScreen()
    
    prev: (event)=>
      event.preventDefault()
      @current--

      if @current<0
        @wrapper.scrollTo @wrapper.find('.item:last'), 0
        @current = @screens-1

      @scrollToScreen()

  return ItemSliderController