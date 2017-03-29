require 'rails_helper'

describe 'Showing user' do
  before do
    @user = create :user, :donald, :with_avatar, about: "# Here's some info about me\n\nBla bla bla."
    login_as(create :admin)
  end

  it 'displays a user' do
    visit user_path(@user)

    expect(page).to have_title 'donald - Base'
    expect(page).to have_active_navigation_items 'Users'
    expect(page).to have_breadcrumbs 'Base', 'Users', 'donald'
    expect(page).to have_headline 'donald'

    within dom_id_selector(@user) do
      expect(page).to have_css '.email',      text: 'donald@example.com'
      expect(page).to have_css '.created_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'
      expect(page).to have_css '.updated_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

      within '.about' do
        expect(page).to have_css 'h2', text: 'About'
        expect(page).to have_css 'h3', text: "Here's some info about me"
        expect(page).to have_content 'Bla bla bla.'
      end

      expect(page).to have_css '.avatar img[alt="donald"]'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end

  # The more thorough tests are implemented for pages#show. As we simply render the same partial here, we just make sure the container is there.
  it 'displays versions' do
    @page = create :page
    visit page_path(@page)

    within '.versions' do
      expect(page).to have_css  'h2', text: 'Versions (0)'
      expect(page).to have_text 'There are no earlier versions'
    end
  end
end
