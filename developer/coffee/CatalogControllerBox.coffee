define [
    'masonry/dist/masonry.pkgd.min'
  ], (
    Masonry
  )->

  class CatalogControllerBox
    constructor: ->
      
      @widget = $ '.main>section.catalog.box'

      if @widget.length == 0
        return
      
      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @widget.find(".item[data-hash='"+document.location.hash.substr(1)+"']").addClass 'full-view'

      @items = $ '#catalog-items'
      # Масонри включаем еcли больше одной колонки доступно
      @msnry = null
      if $(window).width()>=750
        @items.toggleClass 'masonry'
        @items.toggleClass 'not-masonry'
        @msnry = new Masonry '#catalog-items',
          columnWidth: 300
          gutter: 50
          itemSelector: '.item'
          isFitWidth: false
        @msnry.bindResize()
      $(window).resize @resized

      @animatedCookies = 0

      @card = $ 'body>header>nav>.card b'
      $(document).on @itype, '.catalog .item img, .catalog .item .wrapper', @showDetails
      $(document).on @itype, '.catalog .item .details', @switchState
      $(document).on @itype, '.catalog .item .buy', @buyItem

      @totop = $ '.scroll-to-the-box'
      if @totop.length > 0
        @totop.on @itype, @scrollToTheBox
        @box = $ '#box'
        $(window).on 'scroll', @checkIfVisible
        @footer = $ 'body>.main>footer'

    scrollToTheBox: (event)=>
      event.preventDefault()

      $('html, body').animate({
        scrollTop: $("#box").offset().top
      }, 1500);

    checkIfVisible: (event)=>

      docViewTop = $(window).scrollTop()
      docViewBottom = docViewTop + $(window).height()

      elemTop = @box.offset().top
      elemBottom = elemTop + @box.height()

      if (elemBottom>=docViewTop) && (elemTop<=docViewBottom)
        @totop.addClass 'disabled'
      else
        @totop.removeClass 'disabled'
        footerTop = @footer.offset().top
        @totop.css 'bottom', Math.max($(window).height()/2-18, Math.max(0,(20 + docViewBottom - footerTop))) + "px"
        # @totop.css 'bottom', (20 + Math.min(@footer.height(),Math.max(0,(docViewBottom - footerTop)))) + "px"


    resized: (event)=>
      width = $(window).width()
      if width >= 750 && @msnry == null
        @items.toggleClass 'masonry'
        @items.toggleClass 'not-masonry'
        @msnry = new Masonry '#catalog-items',
          columnWidth: 300
          gutter: 50
          itemSelector: '.item'
          isFitWidth: false
        @msnry.bindResize()
      else if width < 750 && @msnry != null
        @items.toggleClass 'masonry'
        @items.toggleClass 'not-masonry'
        @msnry.destroy()
        @msnry = null

    buyItem: (event)=>
      
      event.preventDefault()
      link = $ event.currentTarget
      item = link.closest '.item'
      top_ico = item.attr "data-top-ico"

      card = @card.text()
      count = parseFloat card.substr(1, card.length-2), 10
      if isNaN(count)
        count = 0
      count++
      @card.text "("+count+")"

      $(document.body).addClass 'cookie-animation'

      
      left = 0
      top = 0
      element = item[0]

      while element.parentNode != null
        top += element.offsetTop
        left += element.offsetLeft
        element = element.parentNode

      top += item.height()*0.75
      left += item.width()/2

      img = new Image
      img.src = top_ico
      img.className = 'falling-img'
      img.style.left = left+"px"
      img.style.top = top+"px"
      document.body.appendChild img
      
      @animatedCookies+=1

      window.setTimeout =>
          img.className = 'falling-img drop'
        , 0

      window.setTimeout =>
          img.className = 'falling-img fly'
          img.style.left = "50%"
          img.style.top = "0"
          img.style.opacity = 0

        , 300

      window.setTimeout =>
          
          @animatedCookies-=1

          img.parentNode.removeChild img
          if @animatedCookies == 0
            $(document.body).removeClass 'cookie-animation'
        , 2000

    showDetails: (event)=>
      link = $ event.currentTarget
      item = link.closest '.item'
      
      if item.hasClass('full-view') || @items.hasClass('not-masonry')
        return

      @widget.find('.full-view').removeClass 'full-view'
      item.addClass 'full-view'

      if history.pushState
        history.pushState null, null, '#'+item.attr('data-hash')
      else
        document.location.hash = '#'+item.attr('data-hash')

      if @msnry != null
        @msnry.layout()

    switchState: (event)=>
      event.preventDefault()
      link = $ event.currentTarget
      item = link.closest '.item'
      if !item.hasClass 'full-view'
        @widget.find('.full-view').removeClass 'full-view'
        item.addClass 'full-view'
        if history.pushState
          history.pushState null, null, '#'+item.attr('data-hash')
        else
          document.location.hash = '#'+item.attr('data-hash')
      else
        item.removeClass 'full-view'
        if history.pushState
          history.pushState "", document.title, window.location.pathname
      if @msnry != null
        @msnry.layout()

      

  return CatalogControllerBox


