require 'rails_helper'

describe 'Editing page' do
  before { login_as create :admin }

  it 'grants permission to edit a page' do
    @page = create :page

    visit edit_page_path(@page)

    expect(page).to have_title 'Edit Page test title - Base'
    expect(page).to have_active_navigation_items 'Success Criteria'
    expect(page).to have_breadcrumbs 'Base', 'Pages', 'Page test title', 'Edit'
    expect(page).to have_headline 'Edit Page test title'

    fill_in 'page_title',            with: 'A new title'
    fill_in 'page_navigation_title', with: 'A new navigation title'
    fill_in 'page_content',          with: 'A new content'
    fill_in 'page_notes',            with: 'A new note'

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
      .and change { @page.content }.to('A new content')
      .and change { @page.notes }.to('A new note')
  end

  it "prevents from overwriting other users' changes accidently (caused by race conditions)" do
    @page = create :page
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