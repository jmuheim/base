@Adg = {}

class Adg.Base
  uniqueIdCount = 1
  
  config =
    debugMessage:   false
    hiddenCssClass: 'adg-visually-hidden'
  
  # Constructor. Should not be overridden; use @init() instead.
  #
  # - Arg1: The DOM element on which the script should be applied (will be saved as @$el)
  # - Arg2: An optional hash of options which will be merged into the global default config
  constructor: (el, options = {}) ->
    @config = config

    @$el = $(el)

    for key, val of options
      @config[key] = val
    
    @init()

  # Dummy, must be overridden in inheriting classes.
  init: ->
    @throwMessageAndPrintObjectsToConsole 'Classes extending App must implement method init()!'

  # Prints the given message to the console if config['debug'] is true.
  debugMessage: (message) ->
    console.log "Adg debug: #{message}" if @config.debugMessage

  # Executes the given selector on @$el and returns the element. Makes sure exactly one element exists.
  findOne: (selector) ->
    result = @$el.find(selector)
    switch result.length
      when 0 then @throwMessageAndPrintObjectsToConsole "No object found for #{selector}!", result: result
      when 1 then $(result.first())
      else @throwMessageAndPrintObjectsToConsole "More than one object found for #{selector}!", result: result
        
  name: ->
    "adg-#{@constructor.name.toLowerCase()}"
        
  addAdgDataAttribute: ($target, name, value = '') ->
    $target.attr(@adgDataAttributeName(name), value)
        
  removeAdgDataAttribute: ($target, name) ->
    $target.removeAttr(@adgDataAttributeName(name))
    
  adgDataAttributeName: (name) ->
    "data-#{@name()}-#{name}"
    
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

# Tested in JAWS+IE/FF, NVDA+FF
#
# Known issues:
# - JAWS leaves the input when using up/down without entering something (I guess this is due to screen layout and can be considered intended)
# - Alert not perceivable upon opening suggestions using up/down
#     - Possible solution 1: always show suggestions count when filter focused?
#     - Possible solution 2: wait a moment before adding the alert?
# - VoiceOver/iOS announces radio buttons as disabled?!
# - iOS doesn't select all text when suggestion was chosen
#
# In general: alerts seem to be most robust in all relevant browsers, but aren't polite. Maybe we'll find a better mechanism to serve browsers individually?
class Adg.Autocomplete extends Adg.Base
  config =
    suggestionsContainer: 'fieldset'
    suggestionsContainerLabel: 'legend'
    alertsContainerId: 'alerts'
  
  init: ->
    # Merge config into existing one (not nice, see https://stackoverflow.com/questions/47721699/)
    for key, val of config
      @config[key] = val
    
    @debugMessage 'start'

    @initFilter()
    @initSuggestions()
    @initAlerts()
    
    @announceSuggestionsCount('')

    @attachEvents()
    
  initFilter: ->
    @$filter = @findOne('input[type="text"]')
    @addAdgDataAttribute(@$filter, 'filter')
    
  initSuggestions: ->
    @$suggestionsContainer = @findOne(@config.suggestionsContainer)
    @addAdgDataAttribute(@$suggestionsContainer, 'suggestions')
    
    @$suggestionsContainerLabel = @findOne(@config.suggestionsContainerLabel)
    @$suggestionsContainerLabel.addClass(@config.hiddenCssClass)
    
    @$suggestions = @$suggestionsContainer.find('input[type="radio"]')
    @addAdgDataAttribute(@labelOfInput(@$suggestions), 'suggestion')
    @$suggestions.addClass(@config.hiddenCssClass)
    
  initAlerts: ->
    @$alertsContainer = $("<div id='#{@uniqueId(@config.alertsContainerId)}'></div>")
    @$suggestionsContainerLabel.after(@$alertsContainer)
    @$filter.attr('aria-describedby', [@$filter.attr('aria-describedby'), @$alertsContainer.attr('id')].join(' ').trim())
    @addAdgDataAttribute(@$alertsContainer, 'alerts')
  
  attachEvents: ->
    @attachClickEventToFilter()
    @attachChangeEventToFilter()
    
    @attachEscapeKeyToFilter()
    @attachEnterKeyToFilter()
    @attachTabKeyToFilter()
    @attachUpDownKeysToFilter()
    
    @attachChangeEventToSuggestions()
    @attachClickEventToSuggestions()
    
  attachClickEventToFilter: ->
    @$filter.click =>
      @debugMessage 'click filter'
      if @$suggestionsContainer.is(':visible')
        @hideSuggestions()
      else
        @showSuggestions()
      
  attachEscapeKeyToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 27
        if @$suggestionsContainer.is(':visible')
          @applyCheckedSuggestionToFilterAndResetSuggestions()
          e.preventDefault()
        else if @$suggestions.is(':checked')
          @$suggestions.prop('checked', false)
          @applyCheckedSuggestionToFilterAndResetSuggestions()
          e.preventDefault()
        else # Needed for automatic testing only
          $('body').append('<p>Esc passed on.</p>')
      
  attachEnterKeyToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 13
        @debugMessage 'enter'
        if @$suggestionsContainer.is(':visible')
          @applyCheckedSuggestionToFilterAndResetSuggestions()
          e.preventDefault()
        else # Needed for automatic testing only
          $('body').append('<p>Enter passed on.</p>')
      
  attachTabKeyToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 9
        @debugMessage 'tab'
        if @$suggestionsContainer.is(':visible')
          @applyCheckedSuggestionToFilterAndResetSuggestions()
      
  attachUpDownKeysToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 38 || e.which == 40
        if @$suggestionsContainer.is(':visible')
          if e.which == 38
            @moveSelection('up')
          else
            @moveSelection('down')
        else
          @showSuggestions()
       
        e.preventDefault() # TODO: Test!
    
  showSuggestions: ->
    @debugMessage '(show suggestions)'
    @show(@$suggestionsContainer)
    @$filter.attr('aria-expanded', 'true')
    
  hideSuggestions: ->
    @debugMessage '(hide suggestions)'
    @hide(@$suggestionsContainer)
    @$filter.attr('aria-expanded', 'false')
    
  moveSelection: (direction) ->
    $visibleSuggestions = @$suggestions.filter(':visible')
    
    maxIndex = $visibleSuggestions.length - 1
    currentIndex = $visibleSuggestions.index($visibleSuggestions.parent().find(':checked')) # TODO: is parent() good here?!
    
    upcomingIndex = if direction == 'up'
                      if currentIndex <= 0
                        maxIndex
                      else
                        currentIndex - 1
                    else
                      if currentIndex == maxIndex
                        0
                      else
                        currentIndex + 1

    $upcomingSuggestion = $($visibleSuggestions[upcomingIndex])
    $upcomingSuggestion.prop('checked', true).trigger('change')
    
  attachChangeEventToSuggestions: ->
    @$suggestions.change (e) =>
      @debugMessage 'suggestion change'
      @applyCheckedSuggestionToFilter()

  applyCheckedSuggestionToFilterAndResetSuggestions: ->
    @applyCheckedSuggestionToFilter()
    @hideSuggestions()
    @filterSuggestions()
      
  applyCheckedSuggestionToFilter: ->
    @debugMessage '(apply suggestion to filter)'
    
    $previouslyCheckedSuggestionLabel = $("[#{@adgDataAttributeName('suggestion-selected')}]")
    if $previouslyCheckedSuggestionLabel.length == 1
      @removeAdgDataAttribute($previouslyCheckedSuggestionLabel, 'suggestion-selected')
   
    $checkedSuggestion = @$suggestions.filter(':checked')
    if $checkedSuggestion.length == 1
      $checkedSuggestionLabel = @labelOfInput($checkedSuggestion)
      @$filter.val($.trim($checkedSuggestionLabel.text()))
      @addAdgDataAttribute($checkedSuggestionLabel, 'suggestion-selected')
    else
      @$filter.val('')
      
    @$filter.focus().select()
      
  attachClickEventToSuggestions: ->
    @$suggestions.click (e) =>
      @debugMessage 'click suggestion'
      @hideSuggestions()
      
  attachChangeEventToFilter: ->
    @$filter.on 'input propertychange paste', (e) =>
      @debugMessage '(filter changed)'
      @filterSuggestions(e.target.value)
      @showSuggestions()
      
  filterSuggestions: (filter = '') ->
    fuzzyFilter = @fuzzifyFilter(filter)
    visibleCount = 0
    
    @$suggestions.each (i, el) =>
      $suggestion = $(el)
      $suggestionContainer = $suggestion.parent()

      regex = new RegExp(fuzzyFilter, 'i')
      if regex.test($suggestionContainer.text())
        visibleCount++
        @show($suggestionContainer)
      else
        @hide($suggestionContainer)
        
    @announceSuggestionsCount(filter, visibleCount)
    
  announceSuggestionsCount: (filter = @$filter.val(), count = @$suggestions.length) ->
    @$alertsContainer.find('p').remove() # Remove previous alerts (I'm not sure whether this is the best solution, maybe hiding them would be more robust?)
    
    if filter == ''
      message = "#{count} suggestions in total"
    else
      message = "#{count} suggestions for <kbd>#{filter}</kbd>"
      
    @$alertsContainer.append("<p role='alert'><em>#{message}</em></p>")
        
  fuzzifyFilter: (filter) ->
    i = 0
    fuzzifiedFilter = ''
    while i < filter.length
      escapedCharacter = filter.charAt(i).replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") # See https://stackoverflow.com/questions/3446170/escape-string-for-use-in-javascript-regex
      fuzzifiedFilter += "#{escapedCharacter}.*?"
      i++
      
    fuzzifiedFilter