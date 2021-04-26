require 'rails_helper'

describe 'Creating page' do
  before do
    @user = create :user, :editor
    login_as @user
  end

  it 'creates a page and removes abandoned images and codes', js: true do
    [:abandoned, :referenced].each do |code|
      allow_any_instance_of(PagesController).to receive(:open).with("https://codepen.io/api/oembed?url=https://codepen.io/#{code}/pen/code&format=json").and_return '{"title": "A great pen!", "thumbnail_url": "http://example.com/thumbnail.png"}'
      html = double('html null object')
      allow(html).to receive(:read).and_return('Some HTML')
      allow_any_instance_of(PagesController).to receive(:open).with("https://codepen.io/#{code}/pen/code.html").and_return html
      css = double('css null object')
      allow(css).to receive(:read).and_return('Some CSS')
      allow_any_instance_of(PagesController).to receive(:open).with("https://codepen.io/#{code}/pen/code.css").and_return css
      js = double('js null object')
      allow(js).to receive(:read).and_return('Some JavaScript')
      allow_any_instance_of(PagesController).to receive(:open).with("https://codepen.io/#{code}/pen/code.js").and_return js
    end

    parent_page = create :page, creator: @user, title: 'Cool parent page'

    visit new_page_path

    expect(page).to have_title 'Create Page - Base'
    expect(page).to have_active_navigation_items 'Pages', 'Create Page'
    expect(page).to have_breadcrumbs 'Base', 'Pages', 'Create'
    expect(page).to have_headline 'Create Page'

    expect(page).to have_css 'h2', text: 'Organising pages as tree hierarchy', visible: false
    expect(page).to have_css 'h2', text: 'Pasting images and CodePen links as resources', visible: false

    expect(page).to have_css 'h2', text: 'Details'

    within '.page_title .help-block.help-block-small' do
      expect(page).to have_css '.fa.fa-globe'
      expect(page).to have_text 'Multi-lingual'
    end

    within '.page_navigation_title .help-block.help-block-small' do
      expect(page).to have_css '.fa.fa-globe'
      expect(page).to have_text 'Multi-lingual'
    end

    within '.page_content .help-block.help-block-small' do
      expect(page).to have_css '.fa.fa-globe'
      expect(page).to have_text 'Multi-lingual'

      expect(page).to have_css '.fa.fa-paste'
      expect(page).to have_text 'Allows pasting of images and CodePen links as resources'
    end

    within '.page_notes .help-block.help-block-small' do
      expect(page).to have_css '.fa.fa-paste'
      expect(page).to have_text 'Allows pasting of images and CodePen links as resources'
    end

    fill_in 'page_title',            with: 'new title'
    fill_in 'page_navigation_title', with: 'new navigation title'
    fill_in 'page_lead',             with: 'new lead'
    fill_in 'page_content',          with: 'A cool image: ![image](@image-referenced-image), and some code: [](@code-referenced-code)'
    fill_in 'page_notes',            with: 'new notes'

    # Setting a position isn't possible when creating a page
    expect {
      select_from_autocomplete('Cool parent page (#1)', 'page_parent_id', true)
    }.not_to change {
      page.has_css? '#page_position[disabled]'
    }.from(true)

    # Let's add an image that is referenced in the content
    expect {
      click_link 'Create Image'
    } .to change { all('#images .nested-fields').count }.by 1

    nested_field_id = get_latest_nested_field_id(:page_images)
    fill_in "page_images_attributes_#{nested_field_id}_file", with: base64_image[:data]
    fill_in "page_images_attributes_#{nested_field_id}_identifier", with: 'referenced-image'

    # Let's add another image that's not referenced
    click_link 'Create Image'
    nested_field_id = get_latest_nested_field_id(:page_images)
    fill_in "page_images_attributes_#{nested_field_id}_file", with: base64_image[:data]
    fill_in "page_images_attributes_#{nested_field_id}_identifier", with: 'abandoned-image'

    # Let's add a code that is referenced in the content
    expect {
      click_link 'Create Code'
    } .to change { all('#codes .nested-fields').count }.by 1
    expect(page).to have_css '#codes .nested-fields .page_codes_title input:disabled'

    nested_field_id = get_latest_nested_field_id(:page_codes)
    fill_in "page_codes_attributes_#{nested_field_id}_identifier", with: 'referenced-code'

    # Let's add another code that's not referenced
    click_link 'Create Code'
    nested_field_id = get_latest_nested_field_id(:page_codes)
    fill_in "page_codes_attributes_#{nested_field_id}_identifier", with: 'abandoned-code'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create Page'
      expect(page).to have_link 'List of Pages'
    end

    scroll_by(0, 10000) # Otherwise the footer overlaps the element and results in a Capybara::Poltergeist::MouseEventFailed, see http://stackoverflow.com/questions/4424790/cucumber-capybara-scroll-to-bottom-of-page

    click_button 'Create Page'

    expect(page).to have_flash 'Page was successfully created.'
    expect(Page.count).to eq 2

    page = Page.last
    expect(page.parent).to eq parent_page
    expect(page.title).to eq 'new title'
    expect(page.navigation_title).to eq 'new navigation title'
    expect(page.lead).to eq 'new lead'
    expect(page.content).to eq 'A cool image: ![image](@image-referenced-image), and some code: [](@code-referenced-code)'
    expect(page.notes).to eq 'new notes'
    expect(page.creator).to eq @user

    # Only the referenced image is kept
    expect(Image.count).to eq 1
    expect(Image.last.identifier).to eq 'referenced-image'

    # Only the referenced code is kept
    expect(Code.count).to eq 1
    code = Code.last
    expect(code.identifier).to eq 'referenced-code'
    expect(code.thumbnail_url).to eq 'http://example.com/thumbnail.png'
    expect(code.html).to eq 'Some HTML'
    expect(code.css).to eq 'Some CSS'
    expect(code.js).to eq 'Some JavaScript'
  end

  # See https://github.com/layerssss/paste.js/issues/39
  it 'allows to paste ressources into textareas (and that the textareas can be fullscreenized)', js: true do
    visit new_page_path

    within '.pastables' do
      expect(page).to have_css 'h2', text: 'Images'
      expect(page).to have_css 'h2', text: 'Codes'
    end

    # Make sure that the ClipboardToNestedResourcePastabilizer loaded successfully. Some better tests would be good, but don't know how. See https://github.com/layerssss/paste.js/issues/39.
    expect(page).to have_css 'textarea#page_content.pastable'
    expect(page).to have_css 'textarea#page_notes.pastable'

    # Make sure that the TextareaFullscreenizer loaded successfully. Some better tests would be good, but don't know how.
    expect(page).to have_css '.page_lead    .fa.fa-expand', visible: false
    expect(page).to have_css '.page_content .fa.fa-expand', visible: false
    expect(page).to have_css '.page_notes   .fa.fa-expand', visible: false
  end

  # This must be tested because of the following reason: previously, database fields that were set to NOT NULL were validated using model validations (validates presence: true). Now with several translations, all translated fields must allow NULL, otherwise the app crashes.
  it 'allows to create a page in German' do
    visit new_page_path locale: :de # Default locale (English)

    fill_in 'page_title', with: 'German title'
    click_button 'Seite erstellen'

    expect(page).to have_flash 'Seite wurde erfolgreich erstellt.'
  end

  it 'offers dialogs with information about pages and pastables', js: true do
    visit new_page_path

    expect(page).to have_css 'button#toggle_pages_info', text: "Dialog:\nPages"

    expect {
      click_button 'Dialog: Pages'
    }.to change { page.has_css?('#pages_info[role="dialog"]') }.to(true)
    .and change { page.has_text? 'Organising pages as tree hierarchy' }.to true

    sleep 1 # Timing issue: needed after upgrade from Chromedriver 87 to 90.
    expect(focused_element_id).to eq 'pages_info'

    within '#pages_info' do
      click_button 'Close dialog'
    end

    expect(page).to have_css 'button#toggle_pastables_info', text: "Dialog:\nPastables"
    expect(page).to have_css('#pastables_info[role="dialog"]', visible: false)
  end
end
