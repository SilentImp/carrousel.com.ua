define [
    'viewport-units-buggyfill/viewport-units-buggyfill'
  ], (
    buggyfill
  )->

  class MapController
    constructor: ()->

      buggyfill.init()
      
      @itype = 'click'
      if $('html').hasClass 'touch'
        @itype = 'touchstart'

      if !!navigator.userAgent.match(/i(Pad|Phone|Pod).+(Version\/7\.\d+ Mobile)/i)
        $('.yammy-map .map').css('height', window.innerHeight * 0.9);

      @footerMap = null

      ymaps.ready @init
      
    init: =>
      @footerMap = document.getElementById "footer-map"
      if @footerMap != null
        @initFooterMap()

      @contactsMap =  document.getElementById "contacts-map"
      if @contactsMap != null
        @initContactsMap()

    initContactsMap: =>
      $.getJSON @contactsMap.getAttribute("data-json"), {}, @jsonLoaded

    getPlaceBody: (place)=>
      html = ''

      if place.cell.length>0
        for tel in place.cell
          html+= '<p class="tel">моб. <a href="tel:'+tel+'">'+tel+'</a></p>'

      if place.tel.length>0
        for tel in place.tel
          html+= '<p class="tel">тел. <a href="tel:'+tel+'">'+tel+'</a></p>'

      if place.email.length>0
        emails = []
        for email in place.email
          emails.push '<a href="mailto:'+email+'">'+email+'</a>'
        html+= '<p class="email">'+emails.join(", ")+'</p>'

      html+= '<p class="adr">'+place.adr+'</p>'

      return html
      
    jsonLoaded: (data)=>
      @json = data.address

      smallest = [null, null]
      biggest = [null, null]

      for place in @json
        
        coords = [place.pos.lng, place.pos.lat]
        
        properties = 
          balloonContentHeader: place.title
          balloonContentBody: @getPlaceBody(place),
          balloonAutoPan: true,
          balloonAutoPanCheckZoomRange: true,

        options = 
          iconLayout: 'default#image',
          iconImageHref: "images/map/marker-2.png",
          iconImageSize: [48, 57],
          iconImageOffset: [-20, -57],
          hasBalloon: true,
          openBalloonOnClick: true,
          openEmptyBalloon: true

        if place.central==true
          central = coords
          options.iconImageHref = "images/map/marker.png"
          options.iconImageSize = [53, 88]
          options.iconImageOffset = [-25, -88]

        place.marker = new ymaps.Placemark coords, properties, options

        if (smallest[0] < place.pos.lng) || (smallest[0]==null)
          smallest[0] = place.pos.lng

        if (smallest[1] < place.pos.lat) || (smallest[1]==null)
          smallest[1] = place.pos.lat

        if (biggest[0] > place.pos.lng) || (biggest[0]==null)
          biggest[0] = place.pos.lng
        if (biggest[1] > place.pos.lat) || (biggest[1]==null)
          biggest[1] = place.pos.lat

      smallest[0]+= 0.02
      smallest[1]+= 0.02

      biggest[0]-= 0.01
      biggest[1]-= 0.01

      @contactsMap = new ymaps.Map "contacts-map",
        bounds: [biggest, smallest],
        zoom: 14

      @contactsMap.behaviors.disable "scrollZoom"

      for place in @json
        @contactsMap.geoObjects.add place.marker

    initFooterMap: ()=>
      pos = [
        @footerMap.getAttribute('data-lng'), 
        @footerMap.getAttribute('data-lat')
      ]
      map = new ymaps.Map 'footer-map', 
        center: pos,
        zoom: 16

      marker = new ymaps.Placemark pos, {}, {
        iconLayout: 'default#image',
        iconImageHref: "images/map/marker.png"
        iconImageSize: [53, 88]
        iconImageOffset: [-25, -88]
        }
        
      map.behaviors.disable "scrollZoom"
      map.geoObjects.add marker


  return MapController

