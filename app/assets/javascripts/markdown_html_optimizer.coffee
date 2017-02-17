class App.MarkdownHtmlOptimizer
  constructor: (el) ->
    @$el = $(el)

    @hideCaptionFromScreenReaders(@$el)
    # @addFancyboxToLargeImages(@$el)

  # They already see the alt text
  hideCaptionFromScreenReaders: ($el) ->
    $el.find('.figure .caption').attr('aria-hidden', 'true')