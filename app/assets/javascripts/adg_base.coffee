@Adg = {}

class Adg.Base
  uniqueIdCount = 1

  config =
    debug:          false
    hiddenCssClass: 'adg-visually-hidden'

  # Constructor. Should not be overridden; use @init() instead.
  #
  # - Arg1: The DOM element on which the script should be applied (will be saved as @$el)
  # - Arg2: An optional hash of options which will be merged into the global default config
  constructor: (el, options = {}) ->
    @$el = $(el)

    @config = config
    for key, val of options
      @config[key] = val

    @init()

  # Dummy, must be overridden in inheriting classes.
  init: ->
    @throwMessageAndPrintObjectsToConsole 'Classes extending App must implement method init()!'

  # Executes the given selector on @$el and returns the element. Makes sure exactly one element exists.
  findOne: (selector) ->
    result = @$el.find(selector)
    switch result.length
      when 0 then @throwMessageAndPrintObjectsToConsole "No object found for #{selector}!", result: result
      when 1 then $(result.first())
      else @throwMessageAndPrintObjectsToConsole "More than one object found for #{selector}!", result: result

  name: ->
    # "adg-#{@constructor.name.toLowerCase()}"
    "adg-autocomplete"

  addAdgDataAttribute: ($target, name, value = '') ->
    $target.attr(@adgDataAttributeName(name), value)

  removeAdgDataAttribute: ($target, name) ->
    $target.removeAttr(@adgDataAttributeName(name))

  adgDataAttributeName: (name = null) ->
    result = "data-#{@name()}"
    result += "-#{name}" if name
    result

  uniqueId: (name) ->
    [@name(), name, uniqueIdCount++].join '-'

  labelOfInput: ($inputs) ->
    $inputs.map (i, input) =>
      $input = $(input)

      id = $input.attr('id')
      $label = @findOne("label[for='#{id}']")[0]

      if $label.length == 0
        $label = $input.closest('label')
        @throwMessageAndPrintObjectsToConsole "No corresponding input found for input!", input: $input if $label.length == 0

      $label

  show: ($el) ->
    $el.removeAttr('hidden')
    $el.show()

    # TODO Would be cool to renounce CSS and solely use the hidden attribute. But jQuery's :visible doesn't seem to work with it!?
    # @throwMessageAndPrintObjectsToConsole("Element is still hidden, although hidden attribute was removed! Make sure there's no CSS like display:none or visibility:hidden left on it!", element: $el) if $el.is(':hidden')

  hide: ($el) ->
    $el.attr('hidden', '')
    $el.hide()

  throwMessageAndPrintObjectsToConsole: (message, elements = {}) ->
    console.log elements
    throw message

  text: (text, options = {}) ->
    text = @config["#{text}Text"]

    for key, value of options
      text = text.replace "[#{key}]", value

    text
