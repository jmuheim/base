# Allows textareas to be maximized (Zen View) using Esc or clicking a label.
#
# Apply like this:
#
# <textarea data-textarea-fullscreenizer="true"
#   data-textarea-fullscreenizer-toggler-text="Toggle fullscreen (Esc)">
# </textarea>
#
# $('textarea[data-textarea-fullscreenizer="true"]').each(function() {
#   return new App.TextareaFullscreenizer(this);
# });

class App.TextareaFullscreenizer
  BASE_CSS_CLASS =       'textarea-fullscreenizer'
  TOGGLER_CSS_CLASS =    "#{BASE_CSS_CLASS}-toggler"
  FOCUS_CSS_CLASS =      "#{BASE_CSS_CLASS}-focus"
  FULLSCREEN_CSS_CLASS = "#{BASE_CSS_CLASS}-fullscreen"

  constructor: (textarea) ->
    @$textarea = $(textarea)

    @$textarea.wrap("<div class='#{BASE_CSS_CLASS}'></div>")
    @$background = @$textarea.parent()

    togglerText = @$textarea.data("#{TOGGLER_CSS_CLASS}-text")
    @$background.append("<span class='#{TOGGLER_CSS_CLASS}' aria-hidden='true'>#{togglerText}</span>")
    @$toggler = @$background.find(".#{TOGGLER_CSS_CLASS}")

    @attachEvents()

  attachEvents: ->
    @$toggler.click (e) =>
      @toggleFullscreen()

    @$textarea.keyup (e) =>
      if e.keyCode == 27
        @toggleFullscreen()

    @$textarea.on 'focus', =>
      @$background.addClass(FOCUS_CSS_CLASS)

    @$textarea.on 'blur', =>
      @$background.removeClass(FOCUS_CSS_CLASS)

      if @$background.hasClass(FULLSCREEN_CSS_CLASS)
        @toggleFullscreen(false)

  toggleFullscreen: (setFocus = true) ->
    @$background.toggleClass(FULLSCREEN_CSS_CLASS)
    @$textarea.focus() if setFocus
