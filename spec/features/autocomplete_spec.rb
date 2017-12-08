# button#before href="#" Focusable element before
#
# form
#   div data-adg-autocomplete=true
#     .control
#       label for="favorite_hobby_filter" Favorite hobby
#       input#favorite_hobby_filter type="text" aria-expanded="false" autocomplete="off" aria-describedby="favorite_hobby_filter_description"
#
#       fieldset
#         legend Favorite hobby suggestions
#
#         - [:hiking, :dancing, :gardening].each do |hobby|
#           - id = "favorite_hobby_#{hobby}"
#
#           .control
#             input id=id type="radio" name="hobby"
#             label for=id = hobby.capitalize
#
#       #favorite_hobby_filter_description.description Provides auto-suggestions when entering text
#
# button#after href="#" Focusable element after
#
# .visually-hidden
#   position: absolute
#   width: 1px
#   height: 1px
#   overflow: hidden
#   left: -10000px
#
# .control
#   margin: 6px 0
#
# input[type="text"]
#   width: 140px
#
# label
#   display: inline-block
#   width: 120px
#   vertical-align: top
#
# .description
#   margin-left: 120px
#
# fieldset
#   display: none
#   position: absolute
#   background-color: #fff
#   margin: -1px 0 0 120px
#   padding: 0
#   border: 1px solid
#
#   #alerts
#     p
#       margin: 0
#
#       kbd
#         &::before
#           content: '«'
#
#         &::after
#           content: '»'
#
#   .control
#     margin: 0
#
#   label
#     min-width: 144px
#     width: 100%
#     display: block
#
#   label:hover,
#   input[type="radio"]:checked + label
#     cursor: pointer
#     color: #fff
#     background-color: #000
#
# class AdgAutocomplete
#   constructor: (el) ->
#     console.log '---start---'
#     @$el = $(el)
#
#     @$filter = @$el.find('input[type="text"]')
#     @$suggestionsContainer = @$el.find('fieldset')
#     @$suggestions = @$suggestionsContainer.find('input[type="radio"]')
#
#     @$el.find('legend').after("<div id='alerts'></div>")
#     @$alerts = $('#alerts')
#     @$filter.attr('aria-describedby', [@$filter.attr('aria-describedby'), 'alerts'].join(' ').trim())
#
#     @announceSuggestionsCount()
#
#     @addVisualStyles()
#     @attachEvents()
#
#   addVisualStyles: ->
#     @$suggestionsContainer.find('legend').addClass('visually-hidden')
#     @$suggestions.addClass('visually-hidden')
#
#   attachEvents: ->
#     @attachClickEventToFilter()
#     @attachEscEventToFilter()
#     @attachEnterEventToFilter()
#     @attachTabEventToFilter()
#     @attachUpDownEventToFilter()
#     @addChangeEventToFilter()
#
#     @attachChangeEventToSuggestions()
#     @attachClickEventToSuggestions()
#
#   attachClickEventToFilter: ->
#     @$filter.click =>
#       console.log 'click filter'
#       @toggleSuggestionsVisibility()
#
#   attachEscEventToFilter: ->
#     @$filter.keydown (e) =>
#       if e.which == 27
#         console.log 'esc'
#         if @$suggestionsContainer.is(':visible')
#           @applyCheckedSuggestionToFilter()
#           @toggleSuggestionsVisibility()
#           @filterSuggestions()
#           e.preventDefault()
#         else if @$suggestions.is(':checked')
#           @$suggestions.prop('checked', false)
#           @applyCheckedSuggestionToFilter()
#           @filterSuggestions()
#           e.preventDefault()
#         else # Needed for automatic testing only
#           $('body').append('<p>Esc passed on.</p>')
#
#   attachEnterEventToFilter: ->
#     @$filter.keydown (e) =>
#       if e.which == 13
#         console.log 'enter'
#         if @$suggestionsContainer.is(':visible')
#           @applyCheckedSuggestionToFilter()
#           @toggleSuggestionsVisibility()
#           @filterSuggestions()
#           e.preventDefault()
#         else # Needed for automatic testing only
#           $('body').append('<p>Enter passed on.</p>')
#
#   attachTabEventToFilter: ->
#     @$filter.keydown (e) =>
#       if e.which == 9
#         console.log 'tab'
#         if @$suggestionsContainer.is(':visible')
#           @applyCheckedSuggestionToFilter()
#           @toggleSuggestionsVisibility()
#           @filterSuggestions()
#
#   attachUpDownEventToFilter: ->
#     @$filter.keydown (e) =>
#       if e.which == 38 || e.which == 40
#         console.log e.which
#         if @$suggestionsContainer.is(':visible')
#           if e.which == 38
#             @moveSelection('up')
#           else
#             @moveSelection('down')
#         else
#           @toggleSuggestionsVisibility()
#
#         e.preventDefault() # TODO: Test!
#
#   toggleSuggestionsVisibility: ->
#     console.log '(toggle)'
#     @$suggestionsContainer.toggle()
#     @$filter.attr('aria-expanded', (@$filter.attr('aria-expanded') == 'false' ? 'true' : 'false'))
#
#   moveSelection: (direction) ->
#     $visibleSuggestions = @$suggestions.filter(':visible')
#
#     maxIndex = $visibleSuggestions.length - 1
#     currentIndex = $visibleSuggestions.index($visibleSuggestions.parent().find(':checked')) # TODO: is parent() good here?!
#
#     upcomingIndex = if direction == 'up'
#                       if currentIndex <= 0
#                         maxIndex
#                       else
#                         currentIndex - 1
#                     else
#                       if currentIndex == maxIndex
#                         0
#                       else
#                         currentIndex + 1
#
#     $upcomingSuggestion = $($visibleSuggestions[upcomingIndex])
#     $upcomingSuggestion.prop('checked', true).trigger('change')
#
#   attachChangeEventToSuggestions: ->
#     @$suggestions.change (e) =>
#       console.log 'suggestion change'
#       @applyCheckedSuggestionToFilter()
#
#   applyCheckedSuggestionToFilter: ->
#     console.log '(apply suggestion to filter)'
#     @$filter.val($.trim(@$suggestions.filter(':checked').parent().text())).focus().select()
#
#   attachClickEventToSuggestions: ->
#     @$suggestions.click (e) =>
#       console.log 'click suggestion'
#       @toggleSuggestionsVisibility()
#
#   addChangeEventToFilter: ->
#     @$filter.on 'input propertychange paste', (e) =>
#       console.log '(filter changed)'
#       @filterSuggestions(e.target.value)
#       @toggleSuggestionsVisibility() unless @$suggestionsContainer.is(':visible')
#
#   filterSuggestions: (filter = '') ->
#     fuzzyFilter = @fuzzifyFilter(filter)
#     visibleCount = 0
#
#     @$suggestions.each ->
#       $suggestion = $(@)
#       $suggestionContainer = $suggestion.parent()
#
#       regex = new RegExp(fuzzyFilter, 'i')
#       if regex.test($suggestionContainer.text())
#         visibleCount++
#         $suggestionContainer.show()
#       else
#         $suggestionContainer.hide()
#
#     @announceSuggestionsCount(visibleCount, filter)
#
#   # TODO: Alert seems to be most robust in all relevant browsers, but isn't polite. Maybe we'll find a better mechanism to serve browsers individually?
#   announceSuggestionsCount: (count = @$suggestions.length, filter = @$filter.val()) ->
#     @$alerts.find('p').remove() # Remove previous alerts (I'm not sure whether this is the best solution, maybe hiding them would be more robust?)
#
#     if filter == ''
#       message = "#{count} suggestions in total"
#     else
#       message = "#{count} suggestions for <kbd>#{filter}</kbd>"
#
#     @$alerts.append("<p role='alert'><em>#{message}</em></p>")
#
#   fuzzifyFilter: (filter) ->
#     i = 0
#     fuzzifiedFilter = ''
#     while i < filter.length
#       escapedCharacter = filter.charAt(i).replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") # See https://stackoverflow.com/questions/3446170/escape-string-for-use-in-javascript-regex
#       fuzzifiedFilter += "#{escapedCharacter}.*?"
#       i++
#
#     fuzzifiedFilter
#
# $(document).ready ->
#   $('[data-adg-autocomplete]').each ->
#     new AdgAutocomplete @

require 'rails_helper'

describe 'Autocomplete', js: true do
  URL = 'https://s.codepen.io/accessibility-developer-guide/debug/aVMqdb/XxkVwDdXONmM' # Needs to be a non-expired debug view! (The full view doesn't work because it's an iframe.)
  NON_INTERCEPTED_ESC = 'Esc passed on.'
  NON_INTERCEPTED_ENTER = 'Enter passed on.'

  before { visit_autocomplete }

  it 'displays initially as expected (unfocused)' do
    expect_autocomplete_state # All options default to initial state
  end

  describe 'mouse interaction' do
    it 'shows suggestions when clicking into unfocused filter, and hides them when clicking into focused filter' do
      click_filter
      expect_autocomplete_state suggestions_expanded: true,
                                filter_focused:       true,
                                visible_suggestions:  [:favorite_hobby_hiking,
                                                       :favorite_hobby_dancing,
                                                       :favorite_hobby_gardening]

      click_filter
      expect_autocomplete_state suggestions_expanded: false,
                                filter_focused:       true
    end

    it 'selects a suggestion when clicking on it, and hides suggestions' do
      click_filter
      click_suggestion_label 'Dancing'
      expect_autocomplete_state filter_value:       'Dancing',
                                filter_focused:     true,
                                checked_suggestion: 'favorite_hobby_dancing'
    end
  end

  describe 'keyboard interaction' do
    describe 'tab in' do
      it "doesn't show suggestions" do
        focus_filter_with_keyboard
        expect_autocomplete_state filter_focused: true
      end
    end

    describe 'tab out' do
      context 'suggestions invisible' do
        it 'leaves the filter' do
          focus_filter_with_keyboard_and_press :tab
          expect_autocomplete_state
          expect(focused_element_id).to eq 'after'
        end
      end

      context 'suggestions visible' do
        it 'hides suggestions and leaves filter' do
          focus_filter_with_keyboard_and_press :down, :tab
          expect_autocomplete_state
          expect(focused_element_id).to eq 'after'
        end

        context 'selection made' do
          context 'filter applies to selection' do
            it 'keeps the selection and leaves filter' do
              focus_filter_with_keyboard_and_press :down, :down, 'hi', :tab
              expect_autocomplete_state filter_value:       'Hiking',
                                        checked_suggestion: :favorite_hobby_hiking
              expect(focused_element_id).to eq 'after'
            end
          end

          context "filter doesn't apply to selection" do
            it 'keeps the selection and leaves filter' do
              focus_filter_with_keyboard_and_press :down, :down, 'da', :tab
              expect_autocomplete_state filter_value:       'Hiking',
                                        checked_suggestion: :favorite_hobby_hiking
              expect(focused_element_id).to eq 'after'
            end
          end
        end
      end
    end

    describe 'up' do
      context 'suggestions invisible' do
        it 'shows suggestions when suggestions invisible' do
          focus_filter_with_keyboard_and_press :up
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    visible_suggestions:  [:favorite_hobby_hiking,
                                                           :favorite_hobby_dancing,
                                                           :favorite_hobby_gardening]
        end
      end

      context 'suggestions visible' do
        it 'places selection on bottom when no selection' do
          click_filter_and_press :up
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'Gardening',
                                    checked_suggestion:   :favorite_hobby_gardening,
                                    visible_suggestions:  [:favorite_hobby_hiking,
                                                           :favorite_hobby_dancing,
                                                           :favorite_hobby_gardening]
        end

        it 'moves selection up' do
          click_filter_and_press :up, :up
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'Dancing',
                                    checked_suggestion:   :favorite_hobby_dancing,
                                    visible_suggestions:  [:favorite_hobby_hiking,
                                                           :favorite_hobby_dancing,
                                                           :favorite_hobby_gardening]
        end

        it 'wraps selection to bottom when selection on top' do
          click_filter_and_press :down, :up
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'Gardening',
                                    checked_suggestion:   :favorite_hobby_gardening,
                                    visible_suggestions:  [:favorite_hobby_hiking,
                                                           :favorite_hobby_dancing,
                                                           :favorite_hobby_gardening]
        end
      end
    end

    describe 'down' do
      context 'suggestions invisible' do
        it 'shows suggestions when suggestions invisible' do
          focus_filter_with_keyboard_and_press :down
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    visible_suggestions:  [:favorite_hobby_hiking,
                                                           :favorite_hobby_dancing,
                                                           :favorite_hobby_gardening]
        end
      end

      context 'suggestions visible' do
        it 'places selection on top when no selection' do
          click_filter_and_press :down
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'Hiking',
                                    checked_suggestion:   :favorite_hobby_hiking,
                                    visible_suggestions:  [:favorite_hobby_hiking,
                                                           :favorite_hobby_dancing,
                                                           :favorite_hobby_gardening]
        end

        it 'moves selection down' do
          click_filter_and_press :down, :down
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'Dancing',
                                    checked_suggestion:   :favorite_hobby_dancing,
                                    visible_suggestions:  [:favorite_hobby_hiking,
                                                           :favorite_hobby_dancing,
                                                           :favorite_hobby_gardening]
        end

        it 'wraps selection to top when selection on bottom' do
          click_filter_and_press :up, :down
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'Hiking',
                                    checked_suggestion:   :favorite_hobby_hiking,
                                    visible_suggestions:  [:favorite_hobby_hiking,
                                                           :favorite_hobby_dancing,
                                                           :favorite_hobby_gardening]
        end
      end
    end

    describe 'esc' do
      context 'suggestions visible' do
        it 'hides suggestions' do
          click_filter_and_press :escape
          expect(page).not_to have_content NON_INTERCEPTED_ESC
          expect_autocomplete_state filter_focused: true
        end

        context 'selection made' do
          it 'keeps the selection' do
            click_filter_and_press :down, :escape
            expect(page).not_to have_content NON_INTERCEPTED_ESC
            expect_autocomplete_state filter_focused:     true,
                                      filter_value:       'Hiking',
                                      checked_suggestion: :favorite_hobby_hiking
          end
        end
      end

      context 'suggestions invisible' do
        it 'passes the event on' do
          expect {
            click_filter_and_press :enter, :escape
          }.to change { page.has_content? NON_INTERCEPTED_ESC }.to true
          expect_autocomplete_state filter_focused: true
        end

        context 'selection made' do
          it 'resets the selection' do
            click_filter_and_press :down, :down, :enter, :escape
            expect_autocomplete_state filter_focused: true
          end
        end
      end
    end

    describe 'enter' do
      context 'suggestions visible' do
        it 'hides suggestions' do
          click_filter_and_press :enter
          expect(page).not_to have_content NON_INTERCEPTED_ENTER
          expect_autocomplete_state suggestions_expanded: false,
                                    filter_focused:       true
        end

        context 'selection made, filter changed' do
          it 'keeps the selection' do
            click_filter_and_press :down, 'hi', :enter
            expect_autocomplete_state filter_focused:     true,
                                      filter_value:       'Hiking',
                                      checked_suggestion: :favorite_hobby_hiking
          end
        end
      end

      context 'suggestions invisible' do
        it 'submits form' do
          expect {
            focus_filter_with_keyboard_and_press :enter
          }.to change { page.has_content? NON_INTERCEPTED_ENTER }.to true
        end
      end
    end

    describe 'filtering' do
      context 'suggestions invisible' do
        it 'displays suggestions' do
          focus_filter_with_keyboard_and_press 'x'
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'X', # TODO: Why is it capitalised?!
                                    visible_suggestions:  [],
                                    suggestions_count:    '0 suggestions for X'
        end
      end

      context 'suggestions visible' do
        it 'filters suggestions' do
          focus_filter_with_keyboard_and_press 'd'
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'D',
                                    visible_suggestions:  [:favorite_hobby_dancing,
                                                           :favorite_hobby_gardening],
                                    suggestions_count:    '2 suggestions for D'
        end

        it 'filters suggestions in a fuzzy way' do
          focus_filter_with_keyboard_and_press 'dig'
          expect_autocomplete_state suggestions_expanded: true,
                                    filter_focused:       true,
                                    filter_value:         'DIG',
                                    visible_suggestions:  [:favorite_hobby_dancing,
                                                           :favorite_hobby_gardening],
                                    suggestions_count:    '2 suggestions for DIG'
        end
      end
    end
  end

  def visit_autocomplete
    visit URL
  end

  def filter_input
    find('input#favorite_hobby_filter')
  end

  def click_filter_and_press(*keys)
    filter_input.send_keys keys
  end

  def click_filter
    filter_input.click
  end

  def click_suggestion_label(label)
    find('label', text: label).click
  end

  def focus_filter_with_keyboard
    find('button#before').send_keys :tab
  end

  def focus_filter_with_keyboard_and_press(*keys)
    click_filter_and_press [:escape] + keys # Notice: send_keys always clicks on the element first! I'm working around this by simply pressing esc to mimic the initial state as if it were focused by keyboard only. See https://stackoverflow.com/questions/47623217.
  end

  def expect_autocomplete_state(options = {})
    options.reverse_merge! suggestions_expanded:  false,
                           filter_value:          '',
                           filter_focused:        false,
                           checked_suggestion:    nil,
                           visible_suggestions:   [],
                           suggestions_count:     '3 suggestions in total'

    invisible_suggestions = [:favorite_hobby_hiking,
                             :favorite_hobby_dancing,
                             :favorite_hobby_gardening] - options[:visible_suggestions]

    visible = options[:suggestions_expanded] ? true : :hidden

    within '[data-adg-autocomplete]' do
      expect(page).to have_css 'input#favorite_hobby_filter[type="text"]'
      expect(page).to have_css 'input#favorite_hobby_filter[autocomplete="off"]'
      expect(page).to have_css 'input#favorite_hobby_filter[aria-describedby="favorite_hobby_filter_description alerts"]'
      expect(page).to have_css "input#favorite_hobby_filter[aria-expanded='#{options[:suggestions_expanded]}']"

      within 'fieldset[data-adg-autocomplete-suggestions]', visible: visible do
        expect(page).to have_css 'legend[class="visually-hidden"]', visible: visible
        expect(page).not_to have_css 'input[type="radio"]:not(.visually-hidden)'
        expect(page).to have_css 'input[type="radio"][data-adg-autocomplete-suggestion]', visible: false
      end

      expect(find('input#favorite_hobby_filter').value).to eq options[:filter_value]

      if options[:filter_focused] && focused_element_id != 'favorite_hobby_filter'
        fail "The focused element should be favorite_hobby_filter, but it's #{focused_element_id.presence || '(none)'}!"
      elsif !options[:filter_focused] && focused_element_id == 'favorite_hobby_filter'
        fail "The focused element shouldn't be favorite_hobby_filter, but it is!"
      end

      checked_elements = page.all('input[type="radio"]:checked', visible: visible)
      if options[:checked_suggestion]
        if checked_elements.count == 0
          fail "Suggestion #{options[:checked_suggestion]} expected to be checked, but no suggestion is!"
        elsif checked_elements.first[:id].to_s != options[:checked_suggestion].to_s
          fail "Suggestion #{options[:checked_suggestion]} expected to be checked, but #{checked_elements.first[:id]} is!"
        end
      elsif checked_elements.count > 0
        fail "No suggestion expected to be checked, but #{checked_elements.first} is!"
      end

      (options[:visible_suggestions] + invisible_suggestions).each do |suggestion|
        fail "Unknown suggestion #{suggestion}!" unless page.has_css? "input##{suggestion}[type='radio']", visible: false
      end

      options[:visible_suggestions].each do |suggestion|
        fail "Suggestion #{suggestion} expected to be visible, but isn't!" unless page.has_css? "input##{suggestion}[type='radio']"
      end

      invisible_suggestions.each do |suggestion|
        fail "Suggestion #{suggestion} expected to be invisible, but isn't!" if page.has_css? "input##{suggestion}[type='radio']"
      end

      fail "Only one alert at a time must be present, but there are #{length}!" if (length = all('#alerts > *', visible: visible).length) != 1
      expect(page).to have_css '#alerts[data-adg-autocomplete-alerts] p[role="alert"]', text: options[:suggestions_count], visible: visible
    end
  end
end
