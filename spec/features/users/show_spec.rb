require 'rails_helper'

describe 'Showing user' do
  before do
    @user = create :admin, :scrooge
    login_as(@user)
  end

  it 'displays a user' do
    other_user = create :user, :with_avatar, about: "# Here's some info about me\n\nBla bla bla."

    visit user_path(other_user)

    expect(page).to have_title 'User test name - Base'
    expect(page).to have_active_navigation_items 'Users'
    expect(page).to have_breadcrumbs 'Base', 'Users', 'User test name'
    expect(page).to have_headline 'User test name'

    within dom_id_selector(other_user) do
      expect(page).to have_css '.email',      text: 'test@email.com'
      expect(page).to have_css '.created_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'
      expect(page).to have_css '.updated_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

      within '.about' do
        expect(page).to have_css 'h2', text: 'About'
        expect(page).to have_css 'h3', text: "Here's some info about me"
        expect(page).to have_content 'Bla bla bla.'
      end

      expect(page).to have_css '.avatar img[alt="User test name"]'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end

  describe 'created pages' do
    it "doesn't display created pages if none available" do
      visit user_path(@user)

      expect(page).not_to have_css '.created_pages'
    end

    it 'displays created pages if available' do
      @page = create :page, creator: @user
      visit user_path(@user)

      within '.created_pages' do
        expect(page).to have_css 'h2', text: 'Created pages'

        within '#page_1' do
          expect(page).to have_css '.title a',          text: 'Page test title'
          expect(page).to have_css '.navigation_title', text: 'Page test navigation title'
          expect(page).to have_css '.created_at',       text: '15 Jun 14:33'
          expect(page).to have_css '.updated_at',       text: '15 Jun 14:33'
        end
      end

      login_as(other_user = create(:user, :donald))
      visit user_path(other_user)
      expect(page).not_to have_css '.created_pages'
    end
  end

  # The more thorough tests are implemented for pages#show. As we simply render the same partial here, we just make sure the container is there.
  it 'displays versions (if authorized)', versioning: true do
    @user = create :user

    visit user_path(@user)

    within '.versions' do
      expect(page).to have_css 'h2', text: 'Versions (1)'
    end

    login_as(create :user, :donald)
    visit user_path(@user)
    expect(page).not_to have_css '.versions'
  end
end
