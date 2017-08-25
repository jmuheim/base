require 'rails_helper'

describe 'Editing page' do
  before do
    @user = create(:admin)
    login_as @user
  end

  it 'grants permission to edit a page and removes abandoned images', js: true do
    # Admitted, this looks very ugly...
    [:existing, :abandoned, :new].each do |code|
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

    old_page_parent = create :page, creator: @user, title: 'Cool parent page', navigation_title: nil
    new_parent_page = create :page, creator: @user, title: 'Cooler parent page'
    child_of_new_parent_page = create :page, creator: @user, parent: new_parent_page

    @page = create :page, creator: @user, images: [create(:image, creator: @user)], codes: [create(:code, creator: @user)], parent: old_page_parent, navigation_title: 'Cool navigation title'

    visit edit_page_path(@page)

    expect(page).to have_title 'Edit Page test title - Project Manager'
    expect(page).to have_active_navigation_items 'Cool parent page', 'Cool navigation title'
    expect(page).to have_breadcrumbs 'Project Manager', 'Cool parent page', 'Cool navigation title', 'Edit'
    expect(page).to have_headline 'Edit Page test title'

    # Changing the parent disables the position select
    expect {
      select 'Cooler parent page', from: 'page_parent_id'
    }.to change {
      page.has_css? '#page_position[disabled]'
    }.from(false).to true

    # Changing the parent back to the original value re-enables the position select
    expect {
      select 'Cool parent page', from: 'page_parent_id'
    }.to change {
      page.has_css? '#page_position[disabled]'
    }.from(true).to false

    fill_in 'page_title',            with: 'A new title'
    fill_in 'page_navigation_title', with: 'A new navigation title'
    fill_in 'page_content',          with: "A new content with a ![existing image](@image-existing-image) and a ![new image](@image-new-image). Also an ![existing code](@code-existing-code) and a ![new code](@code-new-code). "
    fill_in 'page_notes',            with: 'A new note'
    select 'Cooler parent page', from: 'page_parent_id'

    find('#page_images_attributes_0_file', visible: false).set base64_other_image[:data]
    fill_in 'page_images_attributes_0_identifier', with: 'existing-image'

    fill_in 'page_codes_attributes_0_identifier', with: 'existing-code'

    # Let's add an image that is referenced in the content
    expect {
      click_link 'Create Image'
    } .to change { all('#images .nested-fields').count }.by 1

    scroll_by(0, 10000) # Otherwise the footer overlaps the element and results in a Capybara::Poltergeist::MouseEventFailed, see http://stackoverflow.com/questions/4424790/cucumber-capybara-scroll-to-bottom-of-page
    nested_field_id = get_latest_nested_field_id(:page_images)
    fill_in "page_images_attributes_#{nested_field_id}_identifier", with: 'new-image'
    fill_in "page_images_attributes_#{nested_field_id}_file", with: base64_image[:data]

    # Let's add another image that's not referenced
    click_link 'Create Image'
    nested_field_id = get_latest_nested_field_id(:page_images)
    fill_in "page_images_attributes_#{nested_field_id}_file", with: base64_image[:data]
    fill_in "page_images_attributes_#{nested_field_id}_identifier", with: 'abandoned-image'

    # Let's add a code that is referenced in the content
    expect {
      click_link 'Create Code'
    } .to change { all('#codes .nested-fields').count }.by 1

    scroll_by(0, 10000) # Otherwise the footer overlaps the element and results in a Capybara::Poltergeist::MouseEventFailed, see http://stackoverflow.com/questions/4424790/cucumber-capybara-scroll-to-bottom-of-page
    nested_field_id = get_latest_nested_field_id(:page_codes)
    fill_in "page_codes_attributes_#{nested_field_id}_identifier", with: 'new-code'

    # Let's add another code that's not referenced
    click_link 'Create Code'
    nested_field_id = get_latest_nested_field_id(:page_codes)
    fill_in "page_codes_attributes_#{nested_field_id}_identifier", with: 'abandoned-code'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Update Page'
      expect(page).to have_link 'List of Pages'
    end

    expect {
      click_button 'Update Page'
      @page.reload
    } .to  change { @page.title }.to('A new title')
      .and change { @page.navigation_title }.to('A new navigation title')
      .and change { @page.parent }.from(old_page_parent).to(new_parent_page)
      .and change { @page.position }.from(1).to(2)
      .and change { @page.content }.to("A new content with a ![existing image](@image-existing-image) and a ![new image](@image-new-image). Also an ![existing code](@code-existing-code) and a ![new code](@code-new-code).")
      .and change { @page.notes }.to('A new note')
      .and change { @page.images.count }.by(1)
      .and change { @page.images.first.file.file.identifier }.to('file.png')
      .and change { @page.images.first.identifier }.to('existing-image')
      .and change { @page.images.last.file.file.identifier }.to('file.png')
      .and change { @page.images.last.identifier }.to('new-image')
      .and change { @page.codes.count }.by(1)
      .and change { @page.codes.first.identifier }.to('existing-code')
      .and change { @page.codes.first.html }.to('Some HTML')
      .and change { @page.codes.first.css }.to('Some CSS')
      .and change { @page.codes.first.js }.to('Some JavaScript')
      .and change { @page.codes.last.identifier }.to('new-code')

    # Only the referenced image is kept
    expect(Image.count).to eq 2
    expect(Image.last.identifier).to eq 'new-image'

    # Only the referenced code is kept
    expect(Code.count).to eq 2
    expect(Code.last.identifier).to eq 'new-code'
  end

  it "provides the correct parent and position collections" do
    parent_page = create :page, creator: @user, title: 'Parent page'
    @page = create :page, creator: @user, parent: parent_page, title: 'Page'
    page_child = create :page, creator: @user, parent: @page, title: 'Page child'
    page_sibling = create :page, creator: @user, parent: parent_page, title: 'Page sibling'
    parent_page_sibling = create :page, creator: @user, title: 'Parent page sibling'
    parent_page_sibling_child = create :page, creator: @user, title: 'Parent page sibling child'

    visit edit_page_path(@page)

    expect(all("select#page_parent_id option").map(&:text)).to eq [ '',
                                                                    "Parent page (##{parent_page.id})",
                                                                    "Page sibling (##{page_sibling.id})",
                                                                    "Parent page sibling (##{parent_page_sibling.id})",
                                                                    "Parent page sibling child (##{parent_page_sibling_child.id})"
                                                                  ]

    expect(all("select#page_position option").map(&:text)).to eq [ "Page (##{@page.id})",
                                                                   "Page sibling (##{page_sibling.id})"
                                                                 ]
  end

  it "prevents from overwriting other users' changes accidently (caused by race conditions)" do
    @page = create :page, creator: @user
    visit edit_page_path(@page)

    # Change something in the database...
    expect {
      @page.update_attributes content: 'This is the old content'
    }.to change { @page.lock_version }.by 1

    fill_in 'page_content', with: 'This is the new content, yeah!'

    expect {
      click_button 'Update Page'
      @page.reload
    }.not_to change { @page }

    expect(page).to have_flash('Alert: Page meanwhile has been changed. The conflicting field is: Content.').of_type :alert

    expect {
      click_button 'Update Page'
      @page.reload
    } .to change { @page.content }.to('This is the new content, yeah!')
  end
end
