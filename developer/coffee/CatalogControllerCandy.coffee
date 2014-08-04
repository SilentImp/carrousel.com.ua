define [
    'masonry/dist/masonry.pkgd.min'
  ], (
    Masonry
  )->

  class CatalogControllerCandy
    constructor: ->
      
      @widget = $ '.main>section.catalog.custom-candy'

      if @widget.length == 0
        return
      
      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @widget.find(".item[data-hash='"+document.location.hash.substr(1)+"']").addClass 'full-view'

      @template = document.getElementById 'icon-template'

      @items = $ '#catalog-items'
      # Масонри включаем емли больше одной колонки доступно
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

      @icons = @widget.find '.box-container .icons .wrapper'

      @animatedCookies = 0

      @currentBox = @widget.find '.box-container'
      @currentPrice = @currentBox.find '.price b'
      @currentWeight = @currentBox.find '.weight b'

      @widget.find('.box-container .order').on @itype, @orderBox

      $(document).on @itype, '.catalog .item img, .catalog .item .wrapper', @showDetails
      $(document).on @itype, '.catalog .item .details', @switchState
      $(document).on @itype, '.catalog .item .buy', @buyItem
      $(document).on @itype, '.catalog .box-container .icons .icon', @removeItem

      @checkIfItemsAvailable()

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

    checkIfItemsAvailable: =>
      candys = @currentBox.find '.icon'
      if candys.length > 0
        @currentBox.addClass('ready').find('.order').removeClass 'disabled'
      else
        @currentBox.removeClass('ready').find('.order').addClass 'disabled'

    orderBox: (event)=>
      event.preventDefault()
      button = $ event.currentTarget

      if button.hasClass 'disabled'
        return

      url = @currentBox.attr 'data-url'
      @currentBox.find('.icon').remove()

      @currentBox.attr "data-summ", 0
      @currentBox.attr "data-weight", 0
      @currentPrice.text 0
      @currentWeight.text 0

      card = $('body>header>nav>.card b')
      count = parseFloat card, 10
      if isNaN(count)
        count = 0
      count++
      card.text "("+count+")"

      @checkIfItemsAvailable()

    removeItem: (event)=>
      event.preventDefault()

      item = $ event.currentTarget

      if not item.hasClass 'loaded'
        return
      
      item.removeClass 'loaded'

      price = parseFloat item.attr('data-price'), 10
      summ = parseFloat @currentBox.attr('data-summ'), 10
      summ -= price

      weight = parseFloat item.attr('data-weight'), 10
      summWeight = parseFloat @currentBox.attr('data-weight'), 10
      summWeight -= weight

      @currentBox.attr('data-weight', summWeight)
      @currentBox.attr('data-summ', summ)

      if Math.floor(summ) != summ
        @currentPrice.text summ.toFixed(2)
      else
        @currentPrice.text summ

      if Math.floor(summWeight) != summWeight
        @currentWeight.text summWeight.toFixed(2)
      else
        @currentWeight.text summWeight

      item.remove()

      @checkIfItemsAvailable()

    buyItem: (event)=>
      event.preventDefault()

      link = $ event.currentTarget
      item = link.closest '.item'
      id = item.attr "data-id"
      title = item.find ".item-title"
      price = parseFloat item.attr("data-price"), 10
      weight = parseFloat item.attr("data-weight"), 10
      ico = item.attr "data-ico"
      top_ico = item.attr "data-top-ico"

      summ = parseFloat @currentBox.attr('data-summ'), 10
      summ += price

      summWeight = parseFloat @currentBox.attr('data-weight'), 10
      summWeight += weight

      if Math.floor(summ) != summ
        @currentPrice.text summ.toFixed(2)
      else
        @currentPrice.text summ

      if Math.floor(summWeight) != summWeight
        @currentWeight.text summWeight.toFixed(2)
      else
        @currentWeight.text summWeight

      @currentBox.attr 'data-summ', summ
      @currentBox.attr 'data-weight', summWeight

      empty = @template.content.cloneNode true
      @icons.append empty
      empty = @icons.find('.icon:last') 

      target_left = 0
      target_top = 0
      element = empty[0]

      while element.parentNode != null
        target_top += element.offsetTop
        target_left += element.offsetLeft
        element = element.parentNode

      empty.addClass 'loading'
      empty.attr 'data-id', id
      empty.attr 'data-weight', weight
      empty.attr 'data-price', price
      empty.find(".wrapper").text title.text()
      empty_img = empty.find 'img'

      empty_img.load ()->
        if !$(this.parentNode).hasClass('loading')
          return
        $(this).parent().removeClass('loading').addClass 'loaded'

      empty_img.attr "src", ico

      left = 0
      top = 0
      element = item[0]

      while element.parentNode != null
        top += element.offsetTop
        left += element.offsetLeft
        element = element.parentNode

      top += item.height()*0.75
      left += item.width()/2

      
      $(document.body).addClass 'cookie-animation'

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

      @checkIfItemsAvailable()

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

  return CatalogControllerCandy