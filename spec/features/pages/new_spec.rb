require 'rails_helper'

describe 'Creating page' do
  before do
    @user = create :admin, :scrooge
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

    expect(page).to have_title 'Create Page - Project Manager'
    expect(page).to have_active_navigation_items 'Pages', 'Create Page'
    expect(page).to have_breadcrumbs 'Project Manager', 'Pages', 'Create'
    expect(page).to have_headline 'Create Page'

    fill_in 'page_title',            with: 'new title'
    fill_in 'page_navigation_title', with: 'new navigation title'
    fill_in 'page_content',          with: 'A cool image: ![image](@image-referenced-image), and some code: [](@code-referenced-code)'
    fill_in 'page_notes',            with: 'new notes'

    # Setting a position isn't possible when creating a page
    expect {
      select 'Cool parent page', from: 'page_parent_id'
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
  it 'allows to paste images and codes as nested attributes directly into content and notes textareas', js: true do
    visit new_page_path

    # Make sure that the ClipboardToNestedResourcePastabilizer loaded successfully. Some better tests would be good, but don't know how. See https://github.com/layerssss/paste.js/issues/39.
    expect(page).to have_css '.page_content.text_fullscreen_with_pastable_resources .fa.fa-expand', visible: false
    expect(page).to have_css '.page_notes.text_fullscreen_with_pastable_resources .fa.fa-expand',   visible: false
  end
end
