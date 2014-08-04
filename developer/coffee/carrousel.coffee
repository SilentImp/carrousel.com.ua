requirejs [
    "modernizr/modernizr",
    "jquery/jquery.min",
    "css_browser_selector/css_browser_selector.min"
    "BGSlider",
    "MapController",
    "ItemSliderController",
    "PreviewSliderController",
    "BusketController",
    "OrderController",
    "PseudoSelectController",
    "CatalogControllerCustom",
    "CatalogControllerBox",
    "CatalogControllerCandy"
  ], (
    dummy1, 
    dummy2,
    dummy3,
    BGSlider,
    MapController,
    ItemSliderController,
    PreviewSliderController,
    BusketController,
    OrderController,
    PseudoSelectController,
    CatalogControllerCustom,
    CatalogControllerBox,
    CatalogControllerCandy
  )->
    new OrderController()
    new BGSlider $(".business .slide-show")
    new MapController()
    new BusketController()
    new CatalogControllerCustom()
    new CatalogControllerBox()
    new CatalogControllerCandy()
    for element in $(".item-slider")
      new ItemSliderController $(element)
    for element in $(".items .preview")
      new PreviewSliderController $(element)
    for element in $(".pseudo-select")
      new PseudoSelectController $(element)
    $(document).ready ->
        require ['TemplatePolyfill']
