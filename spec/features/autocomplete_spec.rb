# button#before href="#" Focusable element before
#
# form
#   div data-adg-autocomplete=true
#     .control
#       label for="favorite_hobby_filter" Favorite hobby
#       input#favorite_hobby_filter type="text" aria-expanded="false" autocomplete="off" aria-describedby="favorite_hobby_filter_description"
#
#     fieldset
#       legend Favorite hobby suggestions
#
#       .control
#         input#favorite_hobby_hiking type="radio" name="hobby"
#         label for="favorite_hobby_hiking" Hiking
#
#       .control
#         input#favorite_hobby_dancing type="radio" name="hobby"
#         label for="favorite_hobby_dancing" Dancing
#
#       .control
#         input#favorite_hobby_gardening type="radio" name="hobby"
#         label for="favorite_hobby_gardening" Gardening
#
#     #favorite_hobby_filter_description.description Provides auto-suggestions when entering text
#
# button#after href="#" Focusable element after

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
#   width: 120px
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
#   margin: -7px 0 0 120px
#   padding: 0
#   border: 1px solid
#
#   .control
#     margin: 0
#
#   label
#     width: 124px
#
#   label:hover,
#   input[type="radio"]:checked + label
#     cursor: pointer
#     color: #fff
#     background-color: #000

# class AdgAutocomplete
#   constructor: (el) ->
#     console.log '---start---'
#     @$el = $(el)
#
#     @$filter = @$el.find('input[type="text"]')
#     @$suggestionsContainer = @$el.find('fieldset')
#     @$suggestions = @$suggestionsContainer.find('input[type="radio"]')
#
#     @addVisualStyles()
#     @attachEvents()
#
#   addVisualStyles: ->
#     # @$suggestions.addClass('visually-hidden')
#     # @$suggestionsContainer.find('legend').addClass('visually-hidden')
#
#   attachEvents: ->
#     @attachClickEventToFilter()
#     @attachEscEventToFilter()
#     @attachEnterEventToFilter()
#     @attachTabEventToFilter()
#     # @attachUpDownEventToFilter()
#     # @addChangeEventToFilter()
#     # @addFocusEventToFilter()
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
#           @toggleSuggestionsVisibility()
#           e.preventDefault()
#         else # Needed for automatic testing only
#           $('body').append('<p>Esc passed on.</p>')
#
#   attachEnterEventToFilter: ->
#     @$filter.keydown (e) =>
#       if e.which == 13
#         console.log 'enter'
#         if @$suggestionsContainer.is(':visible')
#           @toggleSuggestionsVisibility()
#           e.preventDefault()
#         else # Needed for automatic testing only
#           $('body').append('<p>Enter passed on.</p>')
#
#   attachTabEventToFilter: ->
#     @$filter.keydown (e) =>
#       if e.which == 9
#         console.log 'tab'
#         if @$suggestionsContainer.is(':visible')
#           @toggleSuggestionsVisibility()
#
#   attachUpDownEventToFilter: ->
#     # @$filter.keydown (e) =>
#     #   if e.which == 38 || e.which == 40
#     #     if @$suggestionsContainer.is(':visible')
#     #       if e.which == 38
#     #         @moveSelection('up')
#     #       else
#     #         @moveSelection('down')
#     #     else
#     #       @toggleSuggestionsVisibility()
#     #
#     #     e.preventDefault()
#
#   toggleSuggestionsVisibility: ->
#     console.log '(toggle)'
#     @$suggestionsContainer.toggle()
#     @$filter.attr('aria-expanded', (@$filter.attr('aria-expanded') == 'false' ? 'true' : 'false'))
#
#   moveSelection: (direction) ->
#     # $visibleSuggestions = @$suggestions.filter(':visible')
#     #
#     # maxIndex = $visibleSuggestions.length - 1
#     # currentIndex = $visibleSuggestions.index($visibleSuggestions.parent().find(':checked')) # TODO: is parent() good here?!
#     #
#     # upcomingIndex = if direction == 'up'
#     #                   if currentIndex == 0
#     #                     maxIndex
#     #                   else
#     #                     currentIndex - 1
#     #                 else
#     #                   if currentIndex == maxIndex
#     #                     0
#     #                   else
#     #                     currentIndex + 1
#     #
#     # $upcomingSuggestion = $($visibleSuggestions[upcomingIndex])
#     # $upcomingSuggestion.prop('checked', true).trigger('change')
#
#   attachChangeEventToSuggestions: ->
#     @$suggestions.change (e) =>
#       console.log 'suggestion change'
#       @applyCheckedSuggestionToFilter()
#
#   applyCheckedSuggestionToFilter: ->
#     console.log '(apply suggestion to filter)'
#     @$filter.val($.trim(@$suggestions.filter(':checked').parent().text()))
#
#   attachClickEventToSuggestions: ->
#     @$suggestions.click (e) =>
#       console.log 'click suggestion'
#       @toggleSuggestionsVisibility()
#       @$filter.focus()
#
#   addChangeEventToFilter: ->
#     # @$filter.on 'change input propertychange paste', (e) =>
#     #   @filterSuggestions(e.target.value)
#     #   @toggleSuggestionsVisibility() unless @$suggestionsContainer.is(':visible')
#
#   addFocusEventToFilter: ->
#     @$filter.focus =>
#       console.log 'focus filter'
#       @toggleSuggestionsVisibility()
#
#   filterSuggestions: (filter) ->
#     @$suggestions.each ->
#       $suggestion = $(@)
#       $suggestionContainer = $suggestion.parent()
#
#       escapedFilter = filter.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") # See https://stackoverflow.com/questions/3446170/escape-string-for-use-in-javascript-regex
#       regex = new RegExp(escapedFilter, 'i')
#
#       if regex.test($suggestionContainer.text())
#         $suggestionContainer.show()
#       else
#         $suggestionContainer.hide()
#
# $(document).ready ->
#   $('[data-adg-autocomplete]').each ->
#     new AdgAutocomplete @

require 'rails_helper'

describe 'Autocomplete', js: true do
  URL = 'https://s.codepen.io/accessibility-developer-guide/debug/VrqoXj/PNrvYLnKPJPM'
  NON_INTERCEPTED_ESC = 'Esc passed on.'
  NON_INTERCEPTED_ENTER = 'Enter passed on.'

  before { visit_autocomplete }

  it 'displays initially as expected (unfocused)' do
    expect_autocomplete_state # All options default to initial state
  end

  describe 'mouse interaction' do
    it 'shows suggestions when clicking into unfocused filter, and hides them when clicking into focused filter' do
      click_filter
      expect_autocomplete_state suggestions_visible: true,
                                filter_focused:      true

      click_filter
      expect_autocomplete_state suggestions_visible: false,
                                filter_focused:      true
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
    it "doesn't show suggestions when focusing the filter" do
      focus_filter_with_keyboard
      expect_autocomplete_state filter_focused: true
    end

    it 'hides suggestions when unfocusing filter' do
      click_filter_and_press :tab
      expect_autocomplete_state
      expect(focused_element_id).to eq 'after'
    end

    describe 'esc' do
      it 'hides suggestions when suggestions visible' do
        click_filter_and_press :escape
        expect(page).not_to have_content NON_INTERCEPTED_ESC
        expect_autocomplete_state suggestions_visible: false,
                                  filter_focused:      true
      end

      it "doesn't do anything when suggestions invisible" do
        expect {
          click_filter_and_press :escape, :escape
        }.to change { page.has_content? NON_INTERCEPTED_ESC }.to true
      end
    end

    describe 'enter' do
      it 'hides suggestions when suggestions visible' do
        click_filter_and_press :enter
        expect(page).not_to have_content NON_INTERCEPTED_ENTER
        expect_autocomplete_state suggestions_visible: false,
                                  filter_focused:      true
      end

      it 'submits form when suggestions invisible' do
        expect {
          click_filter_and_press :enter, :enter
        }.to change { page.has_content? NON_INTERCEPTED_ENTER }.to true
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

  def expect_autocomplete_state(options = {})
    options.reverse_merge! suggestions_visible: false,
                           filter_value: '',
                           filter_focused: false,
                           checked_suggestion: nil

    within '[data-adg-autocomplete]' do
      expect(page).to have_css 'input#favorite_hobby_filter[type="text"]'
      expect(page).to have_css 'input#favorite_hobby_filter[autocomplete="off"]'
      expect(page).to have_css 'input#favorite_hobby_filter[aria-describedby="favorite_hobby_filter_description"]'
      expect(page).to have_css "input#favorite_hobby_filter[aria-expanded='#{options[:suggestions_visible]}']"
      expect(page).to have_css 'fieldset', visible: options[:suggestions_visible]

      expect(find('input#favorite_hobby_filter').value).to eq options[:filter_value]

      if options[:filter_focused] && focused_element_id != 'favorite_hobby_filter'
        fail "The focused element should be favorite_hobby_filter, but it's #{focused_element_id.presence || '(none)'}!"
      elsif !options[:filter_focused] && focused_element_id == 'favorite_hobby_filter'
        fail "The focused element shouldn't be favorite_hobby_filter, but it is!"
      end

      checked_elements = page.all('input[type="radio"]:checked', visible: false)
      if options[:checked_suggestion]
        if checked_elements.count == 0
          fail "Suggestion #{options[:checked_suggestion]} expected to be checked, but no suggestion is!"
        elsif checked_elements.first[:id] != options[:checked_suggestion]
          fail "Suggestion #{options[:checked_suggestion]} expected to be checked, but #{checked_elements.first[:id]} is!"
        end
      elsif checked_elements.count > 0
        fail "No suggestion expected to be checked, but #{checked_elements.first} is!"
      end
    end
  end
end
