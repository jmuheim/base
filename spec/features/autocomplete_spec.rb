require 'rails_helper'

describe 'Autocomplete', js: true do
  NON_INTERCEPTED_ESC = 'Esc passed on.'
  NON_INTERCEPTED_ENTER = 'Enter passed on.'
  
  around(:each) do |example|
    Capybara.using_wait_time 0 { example.run } # No AJAX involved
  end

  before do
    @admin = create :user, :admin
    sign_in_as @admin
    
    create :page, creator: @admin, title: 'Hiking'
    create :page, creator: @admin, title: 'Dancing'
    create :page, creator: @admin, title: 'Gardening'

    visit new_page_path
  end

  it 'displays initially as expected (unfocused)' do
    # TODO: Spec with already checked value!
    expect_autocomplete_state # All options default to initial state
  end

  describe 'mouse interaction' do
    it 'shows options when clicking into unfocused filter, and hides them when clicking into focused filter' do
      click_filter
      expect_autocomplete_state options_expanded: true,
                                filter_focused:   true,
                                visible_options:  [:page_parent_id_1,
                                                   :page_parent_id_2,
                                                   :page_parent_id_3]

      click_filter
      expect_autocomplete_state options_expanded: false,
                                filter_focused:   true
    end

    it 'selects a option when clicking on it, and hides options' do
      click_filter
      click_option_label 'Dancing (#2)'
      expect_autocomplete_state filter_value:   'Dancing (#2)',
                                filter_focused: true,
                                checked_option: 'page_parent_id_2'
    end
  end

  describe 'keyboard interaction' do
    describe 'tab in' do
      it "doesn't show options" do
        focus_filter_with_keyboard
        expect_autocomplete_state filter_focused: true
      end
    end

    describe 'tab out' do
      context 'options invisible' do
        it 'leaves the filter' do
          focus_filter_with_keyboard_and_press :tab
          expect_autocomplete_state
          expect(focused_element_id).not_to eq 'page_parent_id_filter'
        end
      end

      context 'options visible' do
        it 'hides options and leaves filter' do
          focus_filter_with_keyboard_and_press :down, :tab
          expect_autocomplete_state
          expect(focused_element_id).not_to eq 'page_parent_id_filter'
        end

        context 'selection made' do
          context 'filter applies to selection' do
            it 'keeps the selection and leaves filter' do
              focus_filter_with_keyboard_and_press :down, :down, 'hi', :tab
              expect_autocomplete_state filter_value:   'Hiking (#1)',
                                        checked_option: :page_parent_id_1
              expect(focused_element_id).not_to eq 'page_parent_id_filter'
            end
          end

          context "filter doesn't apply to selection" do
            it 'keeps the selection and leaves filter' do
              focus_filter_with_keyboard_and_press :down, :down, 'da', :tab
              expect_autocomplete_state filter_value:   'Hiking (#1)',
                                        checked_option: :page_parent_id_1
              expect(focused_element_id).not_to eq 'page_parent_id_filter'
            end
          end
        end
      end
    end

    describe 'up' do
      context 'options invisible' do
        it 'shows options when options invisible' do
          focus_filter_with_keyboard_and_press :up
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    visible_options:  [:page_parent_id_1,
                                                       :page_parent_id_2,
                                                       :page_parent_id_3]
        end
      end

      context 'options visible' do
        it 'places selection on bottom when no selection' do
          click_filter_and_press :up
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:       true,
                                    filter_value:     'Gardening (#3)',
                                    checked_option:   :page_parent_id_3,
                                    visible_options:  [:page_parent_id_1,
                                                       :page_parent_id_2,
                                                       :page_parent_id_3]
        end

        it 'moves selection up' do
          click_filter_and_press :up, :up
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    filter_value:     'Dancing (#2)',
                                    checked_option:   :page_parent_id_2,
                                    visible_options:  [:page_parent_id_1,
                                                       :page_parent_id_2,
                                                       :page_parent_id_3]
        end

        it 'wraps selection to bottom when selection on top' do
          click_filter_and_press :down, :up
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    filter_value:     'Gardening (#3)',
                                    checked_option:   :page_parent_id_3,
                                    visible_options:  [:page_parent_id_1,
                                                       :page_parent_id_2,
                                                       :page_parent_id_3]
        end
      end
    end

    describe 'down' do
      context 'options invisible' do
        it 'shows options when options invisible' do
          focus_filter_with_keyboard_and_press :down
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    visible_options:  [:page_parent_id_1,
                                                       :page_parent_id_2,
                                                       :page_parent_id_3]
        end
      end

      context 'options visible' do
        it 'places selection on top when no selection' do
          click_filter_and_press :down
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    filter_value:     'Hiking (#1)',
                                    checked_option:   :page_parent_id_1,
                                    visible_options:  [:page_parent_id_1,
                                                       :page_parent_id_2,
                                                       :page_parent_id_3]
        end

        it 'moves selection down' do
          click_filter_and_press :down, :down
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    filter_value:     'Dancing (#2)',
                                    checked_option:   :page_parent_id_2,
                                    visible_options:  [:page_parent_id_1,
                                                       :page_parent_id_2,
                                                       :page_parent_id_3]
        end

        it 'wraps selection to top when selection on bottom' do
          click_filter_and_press :up, :down
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    filter_value:     'Hiking (#1)',
                                    checked_option:   :page_parent_id_1,
                                    visible_options:  [:page_parent_id_1,
                                                       :page_parent_id_2,
                                                       :page_parent_id_3]
        end
      end
    end

    describe 'esc' do
      context 'options visible' do
        it 'hides options' do
          click_filter_and_press :escape
          expect(page).not_to have_content NON_INTERCEPTED_ESC
          expect_autocomplete_state filter_focused: true
        end

        context 'selection made' do
          it 'keeps the selection' do
            click_filter_and_press :down, :escape
            expect(page).not_to have_content NON_INTERCEPTED_ESC
            expect_autocomplete_state filter_focused: true,
                                      filter_value:   'Hiking (#1)',
                                      checked_option: :page_parent_id_1
          end
        end
      end

      context 'options invisible' do
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
      context 'options visible' do
        it 'hides options' do
          click_filter_and_press :enter
          expect(page).not_to have_content NON_INTERCEPTED_ENTER
          expect_autocomplete_state options_expanded: false,
                                    filter_focused:   true
        end

        context 'selection made, filter changed' do
          it 'keeps the selection' do
            click_filter_and_press :down, 'hi', :enter
            expect_autocomplete_state filter_focused: true,
                                      filter_value:   'Hiking (#1)',
                                      checked_option: :page_parent_id_1
          end
        end
      end

      context 'options invisible' do
        it 'submits form' do
          expect {
            focus_filter_with_keyboard_and_press :enter
          }.to change { page.has_content? NON_INTERCEPTED_ENTER }.to true
        end
      end
    end

    describe 'filtering' do
      context 'options invisible' do
        it 'displays options' do
          focus_filter_with_keyboard_and_press 'x'
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    filter_value:     'X', # TODO: Why is it capitalised?!
                                    visible_options:  [],
                                    options_count:    '0 of 3 options for X'
        end
      end

      context 'options visible' do
        it 'filters options' do
          focus_filter_with_keyboard_and_press 'd'
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    filter_value:     'D',
                                    visible_options:  [:page_parent_id_2,
                                                       :page_parent_id_3],
                                    options_count:    '2 of 3 options for D'
        end

        it 'filters options in a fuzzy way' do
          focus_filter_with_keyboard_and_press 'dig'
          expect_autocomplete_state options_expanded: true,
                                    filter_focused:   true,
                                    filter_value:     'DIG',
                                    visible_options:  [:page_parent_id_2,
                                                       :page_parent_id_3],
                                    options_count:    '2 of 3 options for DIG'
        end
      end
    end
  end

  def visit_autocomplete
    visit URL
  end

  def filter_input
    find('input#page_parent_id_filter')
  end

  def click_filter_and_press(*keys)
    filter_input.send_keys keys
  end

  def click_filter
    filter_input.click
  end

  def click_option_label(label)
    find('label', text: label).click
  end

  def focus_filter_with_keyboard
    find('input#page_title').send_keys [:shift, :tab] # A bit clumsy, but makes sure the element is focused without triggering a click event, see https://stackoverflow.com/questions/47623217/
  end

  def focus_filter_with_keyboard_and_press(*keys)
    click_filter_and_press [:escape] + keys # Notice: send_keys always clicks on the element first! I'm working around this by simply pressing esc to mimic the initial state as if it were focused by keyboard only. See https://stackoverflow.com/questions/47623217.
  end

  def expect_autocomplete_state(options = {})
    options.reverse_merge! options_expanded: false,
                           filter_value:     '',
                           filter_focused:   false,
                           checked_option:   nil,
                           visible_options:  [],
                           options_count:    '3 options in total'

    invisible_options = [:page_parent_id_1,
                         :page_parent_id_2,
                         :page_parent_id_3] - options[:visible_options]

    visible = false

    # TODO: Aufteilen in gut benamste Funktionen!
    within '[data-adg-autocomplete]' do
      expect(page).to have_css 'input#page_parent_id_filter[type="text"]'
      expect(page).to have_css 'input#page_parent_id_filter[autocomplete="off"]'
      expect(page).to have_css 'input#page_parent_id_filter[aria-describedby="page_parent_id_filter_help adg-autocomplete-alerts-1"]'
      expect(page).to have_css "input#page_parent_id_filter[aria-expanded='#{options[:options_expanded]}']"

      within 'fieldset[data-adg-autocomplete-options]', visible: visible do
        expect(page).to have_css 'legend.sr-only', visible: visible
        expect(page).not_to have_css 'input[type="radio"]:not(.sr-only)'
        expect(page).to have_css 'input[type="radio"]', visible: false
        expect(page).to have_css 'label[data-adg-autocomplete-option]', visible: false
      end

      expect(find('input#page_parent_id_filter').value).to eq options[:filter_value]

      if options[:filter_focused] && focused_element_id != 'page_parent_id_filter'
        fail "The focused element should be page_parent_id_filter, but it's #{focused_element_id.presence || '(none)'}!"
      elsif !options[:filter_focused] && focused_element_id == 'page_parent_id_filter'
        fail "The focused element shouldn't be page_parent_id_filter, but it is!"
      end
      
      # TODO: checked und selected vereinheitlichen!

      checked_option_labels = page.all('[data-adg-autocomplete-option-selected]', visible: visible)
      if options[:checked_option]
        if checked_option_labels.count == 0
          fail "Option label #{options[:checked_option]} expected to be checked, but no option label is!"
        elsif checked_option_labels.count != 1
          fail "Only one option label #{options[:checked_option]} expected to be checked, but #{checked_option_labels.count} are!"
        elsif checked_option_labels.first[:for].to_s != options[:checked_option].to_s
          fail "Option label #{options[:checked_option]} expected to be checked, but #{checked_options.first[:for]} is!"
        end
      elsif checked_option_labels.count > 0
        fail "No option label expected to be checked, but #{checked_options.first} is!"
      end

      checked_options = page.all('input[type="radio"]:checked', visible: visible)
      if options[:checked_option]
        if checked_options.count == 0
          fail "Option #{options[:checked_option]} expected to be checked, but no option is!"
        elsif checked_options.first[:id].to_s != options[:checked_option].to_s
          fail "Option #{options[:checked_option]} expected to be checked, but #{checked_options.first[:id]} is!"
        end
      elsif checked_options.count > 0
        fail "No option expected to be checked, but #{checked_options.first} is!"
      end

      (options[:visible_options] + invisible_options).each do |option|
        fail "Unknown option #{option}!" unless page.has_css? "input##{option}[type='radio']", visible: false
      end

      options[:visible_options].each do |option|
        fail "Option #{option} expected to be visible, but isn't!" unless page.has_css? "input##{option}[type='radio']"
      end
     
      invisible_options.each do |option|
        fail "Option #{option} expected to be invisible, but isn't!" if page.has_css? "input##{option}[type='radio']"
      end

      alerts_count = all('#adg-autocomplete-alerts-1 > *', visible: visible).length
      fail "Only one alert at a time must be present, but there are #{length}!" if alerts_count != 1
      expect(page).to have_css '#adg-autocomplete-alerts-1[data-adg-autocomplete-alerts] p[role="alert"]', text: options[:options_count], visible: visible
    end
  end
end
