# We use this to change visibility of jump links.
#
# We tried using CSS :focus pseudo class first, but` Capybara doesn't seem to be able to check upon such changes.
# See http://stackoverflow.com/questions/29211158/rspec-capybara-setting-focus-to-an-element-using-jquery-doesnt-apply-focus
class App.VisibilityOnFocusHandler
  HIDDEN_CSS_CLASS = 'sr-only'

  constructor: (el) ->
    @$el = $(el)

    @$el.focusin =>
      @$el.removeClass HIDDEN_CSS_CLASS

    @$el.focusout =>
      @$el.addClass HIDDEN_CSS_CLASS