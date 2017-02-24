class App.MarkdownHtmlOptimizer
  constructor: (el) ->
    @$el = $(el)

    @hideImageCaptionFromScreenReaders(@$el)
    @addEmptyAltIfNoneAvailable(@$el)

  # Pandoc displays the alternative text of images both as alt-attribute of the image and as caption below the image. The latter isn't needed for screen readers, so we hide it using aria-hidden.
  hideImageCaptionFromScreenReaders: ($el) ->
    $el.find('.figure .caption').attr('aria-hidden', 'true')

  # Pandoc doesn't add an empty alt-attribute if the alternative text is left empty. Because screen readers announce the file name in this situation, we add an empty alt-attribute here.
  addEmptyAltIfNoneAvailable: ($el) ->
    $el.find('img:not([alt])').attr('alt', '')