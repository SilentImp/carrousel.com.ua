define [], ()->

  class ConfirmController
    constructor: (obj)->
      
      template = document.getElementById 'popup-template'
      if template == undefined
        return 

      @obj  = obj || {}

      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      @obj.title = @obj.title || ""
      @obj.message = @obj.message || ""
      
      @obj.agree = @obj.agree || ()->
      if typeof @obj.agree != 'function'
        @obj.agree = ()->
      @obj.agreeArgs = @obj.agreeArgs || []
      @obj.agreeContext = @obj.agreeContext || @

      @obj.decline = @obj.decline || ()->
      if typeof @obj.decline != 'function'
        @obj.decline = ()->
      @obj.declineArgs = @obj.declineArgs || []
      @obj.declineContext = @obj.declineContext || @

      @obj.cancel = @obj.cancel || ()->
      if typeof @obj.cancel != 'function'
        @obj.cancel = ()->
      @obj.cancelArgs = @obj.cancelArgs || []
      @obj.cancelContext = @obj.cancelContext || @

      @popup = template.content.cloneNode(true)

      title = @popup.querySelector '.popup-title'
      title.textContent = @obj.title

      message = @popup.querySelector '.popup-message'
      message.textContent = @obj.message

      @lightbox = @popup.querySelector '.lightbox'
      @box = @popup.querySelector '.popup'

      @popup.querySelector('.agree').addEventListener @itype, @yes
      @popup.querySelector('.decline').addEventListener @itype, @no
      @popup.querySelector('.cancel').addEventListener @itype, @cancel

      document.body.appendChild @popup

    close: =>
      @lightbox.style.opacity = 0
      @box.style.opacity = 0
      window.setTimeout =>
          @lightbox.parentNode.removeChild @lightbox
          @box.parentNode.removeChild @box
        , 400

    yes: (event)=>
      event.preventDefault()
      @obj.agree.apply(@obj.agreeContext, @obj.agreeArgs)
      @close()

    no: (event)=>
      event.preventDefault()
      @obj.decline.apply(@obj.declineContext, @obj.declineArgs)
      @close()

    cancel: (event)=>
      event.preventDefault()
      @obj.cancel.apply(@obj.cancelContext, @obj.cancelArgs)
      @close()


  return ConfirmController