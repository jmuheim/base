require 'rails_helper'

describe 'Autocomplete', js: true do
  URL = 'https://s.codepen.io/accessibility-developer-guide/debug/aVMqdb/jVMpogKKpLgk' # Needs to be a non-expired debug view! (The full view doesn't work because it's an iframe.)
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

    # TODO: Aufteilen in gut benamste Funktionen!
    within '[data-adg-autocomplete]' do
      expect(page).to have_css 'input#favorite_hobby_filter[type="text"]'
      expect(page).to have_css 'input#favorite_hobby_filter[autocomplete="off"]'
      expect(page).to have_css 'input#favorite_hobby_filter[aria-describedby="favorite_hobby_filter_description adg-autocomplete-alerts-1"]'
      expect(page).to have_css "input#favorite_hobby_filter[aria-expanded='#{options[:suggestions_expanded]}']"

      within 'fieldset[data-adg-autocomplete-suggestions]', visible: visible do
        expect(page).to have_css 'legend[class="adg-visually-hidden"]', visible: visible
        expect(page).not_to have_css 'input[type="radio"]:not(.adg-visually-hidden)'
        expect(page).to have_css 'input[type="radio"]', visible: false
        expect(page).to have_css 'label[data-adg-autocomplete-suggestion]', visible: false
      end

      expect(find('input#favorite_hobby_filter').value).to eq options[:filter_value]

      if options[:filter_focused] && focused_element_id != 'favorite_hobby_filter'
        fail "The focused element should be favorite_hobby_filter, but it's #{focused_element_id.presence || '(none)'}!"
      elsif !options[:filter_focused] && focused_element_id == 'favorite_hobby_filter'
        fail "The focused element shouldn't be favorite_hobby_filter, but it is!"
      end
      
      # TODO: checked und selected vereinheitlichen!
      
      checked_suggestion_labels = page.all('[data-adg-autocomplete-suggestion-selected]', visible: visible)
      if options[:checked_suggestion]
        if checked_suggestion_labels.count == 0
          fail "Suggestion label #{options[:checked_suggestion]} expected to be checked, but no suggestion label is!"
        elsif checked_suggestion_labels.count != 1
          fail "Only one suggestion label #{options[:checked_suggestion]} expected to be checked, but #{checked_suggestion_labels.count} are!"
        elsif checked_suggestion_labels.first[:for].to_s != options[:checked_suggestion].to_s
          fail "Suggestion label #{options[:checked_suggestion]} expected to be checked, but #{checked_suggestions.first[:for]} is!"
        end
      elsif checked_suggestion_labels.count > 0
        fail "No suggestion label expected to be checked, but #{checked_suggestions.first} is!"
      end

      checked_suggestions = page.all('input[type="radio"]:checked', visible: visible)
      if options[:checked_suggestion]
        if checked_suggestions.count == 0
          fail "Suggestion #{options[:checked_suggestion]} expected to be checked, but no suggestion is!"
        elsif checked_suggestions.first[:id].to_s != options[:checked_suggestion].to_s
          fail "Suggestion #{options[:checked_suggestion]} expected to be checked, but #{checked_suggestions.first[:id]} is!"
        end
      elsif checked_suggestions.count > 0
        fail "No suggestion expected to be checked, but #{checked_suggestions.first} is!"
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

      fail "Only one alert at a time must be present, but there are #{length}!" if (length = all('#adg-autocomplete-alerts-1 > *', visible: visible).length) != 1
      expect(page).to have_css '#adg-autocomplete-alerts-1[data-adg-autocomplete-alerts] p[role="alert"]', text: options[:suggestions_count], visible: visible
    end
  end
end
