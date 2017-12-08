# Tested in JAWS+IE/FF, NVDA+FF
#
# Known issues:
# - JAWS leaves the input when using up/down without entering something (I guess this is due to screen layout and can be considered intended)
# - Alert not perceivable upon opening suggestions using up/down
#     - Possible solution 1: always show suggestions count when filter focused?
#     - Possible solution 2: wait a moment before adding the alert?
# - VoiceOver/iOS announces radio buttons as disabled?!
# - iOS doesn't select all text when suggestion was chosen
class App.AdgAutocomplete
  defaults =
    hiddenCssClass: 'visually-hidden'
    suggestionsContainer: 'fieldset'
    suggestionsContainerLabel: 'legend'
    alertsContainerId: 'alerts'
  
  constructor: (el, options = {}) ->
    console.log '---start---'
    @$el = $(el)
    
    for key, val of options
      defaults[key] = val
      
    console.log defaults
    
    @$filter = @$el.find('input[type="text"]')
    @$suggestionsContainer = @$el.find(defaults['suggestionsContainer'])
    @$suggestions = @$suggestionsContainer.find('input[type="radio"]')
    
    @$el.find(defaults['suggestionsContainerLabel']).after("<div id='#{defaults['alertsContainerId']}'></div>")
    @$alerts = $("##{defaults['alertsContainerId']}")
    @$filter.attr('aria-describedby', [@$filter.attr('aria-describedby'), defaults['alertsContainerId']].join(' ').trim())
    
    @announceSuggestionsCount()

    @addVisualStyles()
    @attachEvents()
    
  addVisualStyles: ->
    @$suggestionsContainer.find(defaults['suggestionsContainerLabel']).addClass(defaults['hiddenCssClass'])
    @$suggestions.addClass(defaults['hiddenCssClass'])
  
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
      # console.log 'focus out'
      # @toggleSuggestionsVisibility()
    
  attachClickEventToFilter: ->
    @$filter.click =>
      console.log 'click filter'
      @toggleSuggestionsVisibility()
      
  attachEscEventToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 27
        console.log 'esc'
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
        console.log 'enter'
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
        console.log 'tab'
        if @$suggestionsContainer.is(':visible')
          @applyCheckedSuggestionToFilter()
          @toggleSuggestionsVisibility()
          @filterSuggestions()
      
  attachUpDownEventToFilter: ->
    @$filter.keydown (e) =>
      if e.which == 38 || e.which == 40
        console.log e.which
        if @$suggestionsContainer.is(':visible')
          if e.which == 38
            @moveSelection('up')
          else
            @moveSelection('down')
        else
          @toggleSuggestionsVisibility()
       
        e.preventDefault() # TODO: Test!
      
  toggleSuggestionsVisibility: ->
    console.log '(toggle)'
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
      console.log 'suggestion change'
      @applyCheckedSuggestionToFilter()
      
  applyCheckedSuggestionToFilter: ->
    console.log '(apply suggestion to filter)'
    @$filter.val($.trim(@$suggestions.filter(':checked').parent().text())).focus().select()
      
  attachClickEventToSuggestions: ->
    @$suggestions.click (e) =>
      console.log 'click suggestion'
      @toggleSuggestionsVisibility()
      
  addChangeEventToFilter: ->
    @$filter.on 'input propertychange paste', (e) =>
      console.log '(filter changed)'
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