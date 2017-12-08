@Adg = {}

class Adg.Base
  config =
    configDebugMessage: false
    hiddenCssClass:     'visually-hidden'

  # Constructor. Should not be overridden; use @init() instead.
  #
  # - Arg1: The DOM element on which the script should be applied (will be saved as @$el)
  # - Arg2: An optional hash of options which will be merged into the global default options
  constructor: (el, options = {}) ->
    @$el = $(el)

    for key, val of config
      @[key] = val

    for key, val of options
      @[key] = val

    @init()

  # Dummy, must be overridden in inheriting classes.
  init: ->
    throw 'Classes extending App must implement method init()!'

  # Prints the given message to the console if config['debug'] is true.
  debugMessage: (message) ->
    console.log "Adg debug: #{message}" if @configDebugMessage

  # Executes the given selector on @$el and returns the element. Makes sure exactly one element exists.
  findOne: (selector) ->
    result = @$el.find(selector)
    switch result.length
      when 0 then throw "No object found for #{selector}! Result: #{result}."
      when 1 then $(result.first())
      else throw "More than one object found for #{selector}! Result: #{result}."

# Tested in JAWS+IE/FF, NVDA+FF
#
# Known issues:
# - JAWS leaves the input when using up/down without entering something (I guess this is due to screen layout and can be considered intended)
# - Alert not perceivable upon opening suggestions using up/down
#     - Possible solution 1: always show suggestions count when filter focused?
#     - Possible solution 2: wait a moment before adding the alert?
# - VoiceOver/iOS announces radio buttons as disabled?!
# - iOS doesn't select all text when suggestion was chosen
class Adg.Autocomplete extends Adg.Base
  config =
    suggestionsContainer: 'fieldset'
    suggestionsContainerLabel: 'legend'
    alertsContainerId: 'alerts'
  
  init: ->
    for key, val of config
      @[key] = val
    
    @debugMessage 'start'

    @initFilter()
    @initSuggestions()
    @initAlerts()
    
    @announceSuggestionsCount()

    @addVisualStyles()
    @attachEvents()
    
  initFilter: ->
    @$filter = @findOne('input[type="text"]')
    @$filter.attr('data-adg-autocomplete-filter', '')
    
  initSuggestions: ->
    @$suggestionsContainer = @findOne(@suggestionsContainer)
    @$suggestionsContainer.attr('data-adg-autocomplete-suggestions', '')
    
    @$suggestions = @$suggestionsContainer.find('input[type="radio"]')
    @$suggestions.attr('data-adg-autocomplete-suggestion', '')
    
  initAlerts: ->
    @findOne(@suggestionsContainerLabel).after("<div id='#{@alertsContainerId}'></div>")
    @$alerts = $("##{@alertsContainerId}")
    @$filter.attr('aria-describedby', [@$filter.attr('aria-describedby'), @alertsContainerId].join(' ').trim())
    @$alerts.attr('data-adg-autocomplete-alerts', '')
    
  addVisualStyles: ->
    @$suggestionsContainer.find(@suggestionsContainerLabel).addClass(@hiddenCssClass)
    @$suggestions.addClass(@hiddenCssClass)
  
  attachEvents: ->
    @attachClickEventToFilter()
    @attachEscEventToFilter()
    @attachEnterEventToFilter()
    @attachFocusoutEventToFilter()
    @attachTabEventToFilter()
    @attachUpDownEventToFilter()
    @addChangeEventToFilter()
    
    @attachChangeEventToSuggestions()
    @attachClickEventToSuggestions()
    
  attachFocusoutEventToFilter: ->
    @$filter.focusout =>
      # TODO: Hide unless clicked into suggestions!
      # @debugMessage 'focus out'
      # @toggleSuggestionsVisibility()
    
  attachClickEventToFilter: ->
    @$filter.click =>
      @debugMessage 'click filter'
      @toggleSuggestionsVisibility()
      
  attachEscEventToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 27
        @debugMessage 'esc'
        if @$suggestionsContainer.is(':visible')
          @applyCheckedSuggestionToFilter()
          @toggleSuggestionsVisibility()
          @filterSuggestions()
          e.preventDefault()
        else if @$suggestions.is(':checked')
          @$suggestions.prop('checked', false)
          @applyCheckedSuggestionToFilter()
          @filterSuggestions()
          e.preventDefault()
        else # Needed for automatic testing only
          $('body').append('<p>Esc passed on.</p>')
      
  attachEnterEventToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 13
        @debugMessage 'enter'
        if @$suggestionsContainer.is(':visible')
          @applyCheckedSuggestionToFilter()
          @toggleSuggestionsVisibility()
          @filterSuggestions()
          e.preventDefault()
        else # Needed for automatic testing only
          $('body').append('<p>Enter passed on.</p>')
      
  attachTabEventToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 9
        @debugMessage 'tab'
        if @$suggestionsContainer.is(':visible')
          @applyCheckedSuggestionToFilter()
          @toggleSuggestionsVisibility()
          @filterSuggestions()
      
  attachUpDownEventToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 38 || e.which == 40
        if @$suggestionsContainer.is(':visible')
          if e.which == 38
            @moveSelection('up')
          else
            @moveSelection('down')
        else
          @toggleSuggestionsVisibility()
       
        e.preventDefault() # TODO: Test!
      
  toggleSuggestionsVisibility: ->
    @debugMessage '(toggle)'
    @$suggestionsContainer.toggle()
    @$filter.attr('aria-expanded', (@$filter.attr('aria-expanded') == 'false' ? 'true' : 'false'))
    
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
      
  applyCheckedSuggestionToFilter: ->
    @debugMessage '(apply suggestion to filter)'
    @$filter.val($.trim(@$suggestions.filter(':checked').parent().text())).focus().select()
      
  attachClickEventToSuggestions: ->
    @$suggestions.click (e) =>
      @debugMessage 'click suggestion'
      @toggleSuggestionsVisibility()
      
  addChangeEventToFilter: ->
    @$filter.on 'input propertychange paste', (e) =>
      @debugMessage '(filter changed)'
      @filterSuggestions(e.target.value)
      @toggleSuggestionsVisibility() unless @$suggestionsContainer.is(':visible')
      
  filterSuggestions: (filter = '') ->
    fuzzyFilter = @fuzzifyFilter(filter)
    visibleCount = 0
    
    @$suggestions.each ->
      $suggestion = $(@)
      $suggestionContainer = $suggestion.parent()

      regex = new RegExp(fuzzyFilter, 'i')
      if regex.test($suggestionContainer.text())
        visibleCount++
        $suggestionContainer.show()
      else
        $suggestionContainer.hide()
        
    @announceSuggestionsCount(visibleCount, filter)
    
  # TODO: Alert seems to be most robust in all relevant browsers, but isn't polite. Maybe we'll find a better mechanism to serve browsers individually?
  announceSuggestionsCount: (count = @$suggestions.length, filter = @$filter.val()) ->
    @$alerts.find('p').remove() # Remove previous alerts (I'm not sure whether this is the best solution, maybe hiding them would be more robust?)
    
    if filter == ''
      message = "#{count} suggestions in total"
    else
      message = "#{count} suggestions for <kbd>#{filter}</kbd>"
      
    @$alerts.append("<p role='alert'><em>#{message}</em></p>")
        
  fuzzifyFilter: (filter) ->
    i = 0
    fuzzifiedFilter = ''
    while i < filter.length
      escapedCharacter = filter.charAt(i).replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") # See https://stackoverflow.com/questions/3446170/escape-string-for-use-in-javascript-regex
      fuzzifiedFilter += "#{escapedCharacter}.*?"
      i++
      
    fuzzifiedFilter