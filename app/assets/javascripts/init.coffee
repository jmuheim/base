class App.Init
  constructor: (el) ->
    @$el = $(el)

    @makeJumpLinksVisibleOnFocus @$el
    @makeFormsAccessible @$el
    @makeTextareasPasteable @$el
    @makeTextareasPasteableToNestedImage @$el
    @optimizeMarkdownGeneratedHtml @$el
    @initTooltips @$el
    @initFancybox @$el
    @makeTextareasFullscreenizable @$el

  makeJumpLinksVisibleOnFocus: ($el) ->
    $el.find('#jump_links a').each ->
      new App.VisibilityOnFocusHandler @

  makeFormsAccessible: ($el) ->
    $el.find('form.simple_form').each ->
      new App.FormAccessibilizer @

  makeTextareasPasteable: ($el) ->
    $el.find('[data-paste]').each ->
      new App.ClipboardToTextareaPasteabilizer @

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

  makeTextareasPasteableToNestedImage: ($el) ->
    $el.find('textarea[data-pasteable-image="true"]').each ->
      new App.ClipboardToNestedImagePasteabilizer @

  optimizeMarkdownGeneratedHtml: ($el) ->
    new App.MarkdownHtmlOptimizer $el

  makeTextareasFullscreenizable: ($el) ->
    $el.find('textarea[data-textarea-fullscreenizer="true"]').each ->
      new App.TextareaFullscreenizer @
