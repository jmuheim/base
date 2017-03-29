class App.Init
  constructor: (el) ->
    @$el = $(el)

    @makeJumpLinksVisibleOnFocus @$el
    @makeFormsAccessible @$el
    @makeTextareasPastable @$el
    @makeTextareasPastableToNestedImage @$el
    @optimizeMarkdownGeneratedHtml @$el
    @initTooltips @$el
    @initFancybox @$el
    @makeTextareasFullscreenizable @$el
    @disableDependingSelect @$el
    @generateDiffs @$el

  makeJumpLinksVisibleOnFocus: ($el) ->
    $el.find('#jump_links a').each ->
      new App.VisibilityOnFocusHandler @

  makeFormsAccessible: ($el) ->
    $el.find('form.simple_form').each ->
      new App.FormAccessibilizer @

  makeTextareasPastable: ($el) ->
    $el.find('[data-paste]').each ->
      new App.ClipboardToTextareaPastabilizer @

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

  makeTextareasPastableToNestedImage: ($el) ->
    $el.find('textarea[data-pastable-image="true"]').each ->
      new App.ClipboardToNestedImagePastabilizer @

  optimizeMarkdownGeneratedHtml: ($el) ->
    new App.MarkdownHtmlOptimizer $el

  makeTextareasFullscreenizable: ($el) ->
    $el.find('textarea[data-textarea-fullscreenizer="true"]').each ->
      new App.TextareaFullscreenizer @

  disableDependingSelect: ($el) ->
    $el.find('[data-depends-id][data-depends-value]').each ->
      new App.DependingSelectDisabler @, $el

  generateDiffs: ($el) ->
    $el.find('[data-diff]').each ->
      new App.DiffGenerator @
