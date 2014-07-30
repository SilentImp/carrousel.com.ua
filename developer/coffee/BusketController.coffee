define [
    'ConfirmController'
  ], (
    ConfirmController
  )->

  class BusketController
    
    constructor: ->
      @widget = $('.main>.basket')
      if @widget.length == 0
        return

      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @price = @widget.find 'header .price b, footer .price b'
      @delivery_free = @widget.find '.delivery.free'
      @delivery_fee = @widget.find '.delivery.fee'
      @submit = @widget.find '.order'
      @card = $('body>header>nav>.card>b')

      $(document).on @itype, '.inc', @increment
      $(document).on @itype, '.dec', @decrement
      $(document).on @itype, '.remove', @remove
      @submit.on @itype, @order

      @recount()

    order: (event)=>
      event.preventDefault()
      order = {items:[]}
      for item in @widget.find '.item'
        item = $ item
        item_data = 
          id: item.attr('data-id')
          count: parseInt item.attr('data-count'), 10
        order.items.push item_data

      # Отправка заказа…
      $.post 'http://carrousel.com.ua/order/', order


    recount: =>
      summary = 0
      items = @widget.find '.item'
      if(items.length>0)
        @card.text "("+items.length+")"
      else
        @card.text "(хочу сладкого)"
      for item in items
        item = $ item
        

        count = parseInt item.attr('data-count'), 10
        count_display = item.find 'menu span b'
        count_display.text count

        price = parseFloat item.attr('data-price'), 10
        price_display = item.find '.price b'
        summ = count*price

        if summ!=Math.round(summ)
          price_display.text summ.toFixed(2)
        else
          price_display.text summ

        summary+= summ

      if summary>300
        @delivery_free.removeClass 'locked'
        @delivery_fee.addClass 'locked'
      else
        @delivery_free.addClass 'locked'
        @delivery_fee.removeClass 'locked'

      if summary!=Math.round(summary)
        @price.text summary.toFixed(2)
      else
        @price.text summary


    increment: (event)=>
      event.preventDefault()
      button = $ event.currentTarget
      item = button.closest '.item'
      count = parseInt item.attr('data-count'), 10
      item.attr 'data-count', ++count
      @recount()

    decrement: (event)=>
      event.preventDefault()
      button = $ event.currentTarget
      item = button.closest '.item'
      count = parseInt item.attr('data-count'), 10
      item.attr 'data-count', Math.max(--count,0)

      if count==0
        new ConfirmController 
          title: 'Удалить вкусняшку? Точно-точно?'
          message: 'Она очень расстроится…'
          agree: @deleteCookie
          agreeArgs: [item]
          agreeContext: @
          decline: @spareCookie
          declineArgs: [item]
          declineContext: @
          cancel: @spareCookie
          cancelArgs: [item]
          cancelContext: @

      @recount()

    deleteCookie: (item)=>
      rec = @recount
      item.fadeOut ->
        $(this).remove()
        rec()

    spareCookie: (item)=>
      item.find('.inc').trigger 'click'

    remove: (event)=>
      event.preventDefault()
      button = $ event.currentTarget
      item = button.closest '.item'
      new ConfirmController 
        title: 'Удалить вкусняшку? Точно-точно?'
        message: 'Она очень расстроится…'
        agree: @deleteCookie
        agreeArgs: [item]
        agreeContext: @
        decline: @spareCookie
        declineArgs: [item]
        declineContext: @
        cancel: @spareCookie
        cancelArgs: [item]
        cancelContext: @

  return BusketController