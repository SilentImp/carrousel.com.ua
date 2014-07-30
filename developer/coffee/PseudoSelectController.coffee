define [], ()->

  class PseudoSelectController
    
    constructor: (@widget)->
      if @widget.length == 0
        return

      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @current_label = @widget.find '.pseudo-select-current'
      @input = @widget.find '.pseudo-select-input'
      @list = @widget.find '.pseudo-select-list'
      @options = @list.find 'li'

      @list.hide()
      @current_label.on @itype, @show

      @options.on @itype, @selectOption

    show: (event)=>
      @list.toggle()

    selectOption: (event)=>
      option = $ event.currentTarget
      id = option.attr 'data-id'
      @input.val id
      @current_label.text option.text()
      @list.hide()


      
  return PseudoSelectController