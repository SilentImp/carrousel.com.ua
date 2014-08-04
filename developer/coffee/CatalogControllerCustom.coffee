define [
    'masonry/dist/masonry.pkgd.min'
  ], (
    Masonry
  )->

  class CatalogControllerCustom
    constructor: ->
      
      @widget = $ '.main>section.catalog.custom'

      if @widget.length == 0
        return

      @transitions = $('body').hasClass 'csstransitions'
      @transforms = $('body').hasClass  'csstransforms'
      @transform3d = $('body').hasClass 'csstransforms3d'
      
      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @widget.find(".item[data-hash='"+document.location.hash.substr(1)+"']").addClass 'full-view'

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


      @animatedCookies = 0

      @currentBox = @widget.find '.box-container.selected'
      @currentPrice = @currentBox.find '.price b'

      @widget.find('.box-container .order').on @itype, @orderBox

      @box_nav = @widget.find '.box-type'
      @box_nav.find('a').on @itype, @switchBox

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
        # Math.min($(window).height()/2-18, Math.max(0,(docViewBottom - footerTop)))
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
      next_empty = @currentBox.find '.icon:not(.loading):not(.loaded)'
      if next_empty.length == 0
        @widget.find('.items-list .item nav .buy').addClass 'disabled'
        @currentBox.find('.order').removeClass 'disabled'
      else
        @widget.find('.items-list .item nav .buy').removeClass 'disabled'
        @currentBox.find('.order').addClass 'disabled'

    orderBox: (event)=>
      event.preventDefault()
      button = $ event.currentTarget

      if button.hasClass 'disabled'
        return

      items = @currentBox.find '.icon:not(.loading):not(.loaded)'
      if items.length>0
        return

      url = @currentBox.attr 'data-url'
      @currentBox.find('.icon').removeClass('loaded').removeClass('loading').each (items, element)=>
        $(element).find('img').attr("src", url);

      @currentBox.attr "data-summ", 0
      @currentPrice.text 0

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

      @currentBox.attr('data-summ', summ)

      if Math.floor(summ) != summ
        @currentPrice.text summ.toFixed(2)
      else
        @currentPrice.text summ

      item.find('img').attr('src', @currentBox.attr('data-url'))
      @currentBox.find('.icons').append item

      @checkIfItemsAvailable()

    buyItem: (event)=>
      event.preventDefault()

      link = $ event.currentTarget
      item = link.closest '.item'
      id = item.attr "data-id"
      title = item.find ".item-title"
      price = parseFloat item.attr("data-price"), 10
      ico = item.attr "data-ico"
      top_ico = item.attr "data-top-ico"
      summ = parseFloat @currentBox.attr('data-summ'), 10
      summ += price

      if Math.floor(summ) != summ
        @currentPrice.text summ.toFixed(2)
      else
        @currentPrice.text summ

      @currentBox.attr 'data-summ', summ

      empty = @currentBox.find '.icon:not(.loading):not(.loaded):eq(0)'


      target_left = 0
      target_top = 0
      element = empty[0]

      while element.parentNode != null
        target_top += element.offsetTop
        target_left += element.offsetLeft
        element = element.parentNode

      empty.addClass 'loading'
      empty.attr 'data-id', id
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

      img = new Image
      img.src = top_ico
      img.className = 'falling-img'
      img.style.left = left+"px"
      img.style.top = top+"px"
      document.body.appendChild img

      if @transform3d

        $(document.body).addClass 'cookie-animation'
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
      
      else
        img.style.opacity = 1
        $(img).animate {'left':'50%', 'top':'-200px', 'opacity':'0'}, 1000

        window.setTimeout =>
            img.parentNode.removeChild img
          , 2000


      @checkIfItemsAvailable()

    switchBox: (event)=>
      event.preventDefault()
      link = $ event.currentTarget
      target = link.attr 'data-target'

      @box_nav.find('.selected').removeClass 'selected'
      @widget.find('.box-container.selected').removeClass 'selected'

      @currentBox = $ '#'+target

      @currentBox.addClass 'selected'
      @currentPrice = @currentBox.find '.price b'
      link.addClass('selected')

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

  return CatalogControllerCustom


