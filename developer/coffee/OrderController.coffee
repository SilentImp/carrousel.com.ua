define [
  'jquery.maskedinput/jquery.maskedinput.min'
  ], (
    dummy1
  )->

  class OrderController
    
    constructor: ->
      @widget = $('.main>.order')
      if @widget.length == 0
        return

      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @widget.find('input.tel').mask("+380 99 999 99 99");


  return OrderController