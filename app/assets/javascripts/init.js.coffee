class App.Init
  constructor: (el) ->
    @$el = $(el)

    @makeFormsAccessible @$el
    @initTooltips @$el
    @initFancybox @$el

  makeFormsAccessible: ($el) ->
    $el.find('form.simple_form').each ->
      new App.FormAccessibilizer @

  initTooltips: ($el) ->
    # Bootstrap tooltips
    $el.find('[title]').tooltip()

  initFancybox: ($el) ->
    # Fancybox
    $('a.fancybox').fancybox
      openSpeed: 0
      closeSpeed: 0
      nextSpeed: 0
      prevSpeed: 0
      helpers:
        overlay:
          locked: false
          speedOut: 0
        thumbs:
          width: 100,
          height: 100
