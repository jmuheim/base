require 'rails_helper'

describe 'Listing pages' do
  before do
    @user = create :admin
    login_as(@user)
  end

  it 'displays pages' do
    parent_page = create :page, creator: @user
    @page = create :page, creator: @user, images: [create(:image, creator: @user)], navigation_title: 'Page test navigation title', parent: parent_page
    visit pages_path

    expect(page).to have_title 'Pages - Base'
    expect(page).to have_active_navigation_items 'Pages', 'List of Pages'
    expect(page).to have_breadcrumbs 'Base', 'Pages'
    expect(page).to have_headline 'Pages'

    within dom_id_selector(@page) do
      expect(page).to have_css '.title a',          text: 'Page test title'
      expect(page).to have_css '.navigation_title', text: 'Page test navigation title'
      expect(page).to have_css '.ancestors',        text: 1
      expect(page).to have_css '.images',           text: 1
      expect(page).to have_css '.notes',            text: 'Page test notes'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    within 'div.actions' do
      expect(page).to have_css 'h2', text: 'Actions'
      expect(page).to have_link 'Create Page'
    end
  end

  it 'offers an ATOM feed' do
    parent_page = create :page, creator: @user, title: 'Parent page'
    @page = create :page, creator: @user, images: [create(:image, creator: @user)], navigation_title: 'Page test navigation title', parent: parent_page, creator: @user
    visit pages_path format: :atom

    expect(page).to have_title 'Pages - Base Project'

    within 'entry:nth-of-type(1)' do
      expect(page).to have_css 'title', text: 'Parent page'

      within 'author' do
        expect(page).to have_css 'name', text: 'User test name'
        expect(page).to have_css 'uri',  text: '/en/users/1'
      end

      expect(page).to have_css 'summary', text: '<p>Page test lead</p>'

      within 'content' do
        expect(page).to have_content '<h1>Position in page hierarchy</h1>'
        expect(page).to have_content '<ol><li><a href="/en">Base Project</a></li><li><a href="/en/pages/1">Page test navigation title</a></li></ol>'
        expect(page).to have_content '<h1>Content</h1>'
        expect(page).to have_content '<p>Page test content</p>'
        expect(page).to have_content '<h1>Notice about Atom feed</h1>'
        expect(page).to have_content '<p>Your feed reader has downloaded version 0 of the current page, which was current at June 15, 2015 12:33. Meanwhile there could be an updated version of the page available online. Visit the original page to see the most current version!</p>'
      end
    end

    within 'entry:nth-of-type(2)' do
      expect(page).to have_css 'title', text: 'Page test title'

      within 'content' do
        expect(page).to have_content '<ol><li><a href="/en">Base Project</a></li><li><a href="/en/pages/1">Page test navigation title</a></li><li><a href="/en/pages/2">Page test navigation title</a></li></ol>'
      end
    end
  end
end
