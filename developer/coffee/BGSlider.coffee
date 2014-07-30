define [], ()->

  class BGSlider
    constructor: (@widget)->
      if @widget.length == 0
        return
      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @slides = @widget.attr("data-slides").split(",")
      
      if @slides.length<2
        return
      
      for src in @slides
        src = src.trim()

      @dir = true
      @index = 0
      @current_slide = @widget.find ".current.slide"
      @hidden_slide = @widget.find ".slide:not(.current)"
      @widget.find(".slide-show-nav-prev").on @itype, @prev
      @widget.find(".slide-show-nav-next").on @itype, @next

      @loadImg()

    loadImg: =>
      @hidden_slide.removeClass("hidden-prev")
      @hidden_slide.removeClass("hidden-next")
      if @dir
        @hidden_slide.addClass("ready-next")
      else
        @hidden_slide.addClass("ready-prev")
      $('<img>').attr('src', @slides[@index]).load(@cashImg)

    cashImg: (event)=>
      $(event.currentTarget).remove()
      @hidden_slide.css('background-image', 'url('+@slides[@index]+')').addClass("current").removeClass("ready-next").removeClass("ready-prev")
      
      @current_slide.removeClass("current")
      if @dir
        @current_slide.addClass("hidden-next")
      else
        @current_slide.addClass("hidden-prev")
        
      tmp = @current_slide
      @current_slide = @hidden_slide
      @hidden_slide = tmp
        

    next: (event)=>
      event.preventDefault()
      @dir = true
      @index++
      if @index >= @slides.length
        @index = 0
      @loadImg()
    
    prev: (event)=>
      event.preventDefault()
      @dir = false
      @index--
      if @index < 0
        @index = @slides.length-1
      @loadImg()


  return BGSlider