require 'rails_helper'

describe 'Listing users' do
  before do
    @user = create :user
    @admin = create :user, :admin

    login_as(@admin)
  end

  it 'displays users' do
    visit users_path

    expect(page).to have_title 'Users - Base'
    expect(page).to have_active_navigation_items 'Users', 'List of Users'
    expect(page).to have_breadcrumbs 'Base', 'Users'
    expect(page).to have_headline 'Users'

    expect(page).to have_css 'h2', text: 'Filter'
    expect(page).to have_css 'h2', text: 'Results'

    within dom_id_selector(@user) do
      expect(page).to have_css '.name a', text: 'User test name'
      expect(page).to have_css '.email',  text: 'user@example.com'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    within 'div.actions' do
      expect(page).to have_css 'h2', text: 'Actions'
      expect(page).to have_link 'Create User'
    end
  end

  it 'allows to filter users' do
    @user_1 = create :user, name: 'anne', email: 'anne@example.com'
    @user_2 = create :user, name: 'marianne', email: 'marianne@example.com'
    @user_3 = create :user, name: 'eva', email: 'eva@example.com'

    visit users_path

    expect(page).to have_css dom_id_selector(@user_1)
    expect(page).to have_css dom_id_selector(@user_2)
    expect(page).to have_css dom_id_selector(@user_3)

    fill_in 'q_name_cont', with: 'anne'
    click_button 'Apply filter'

    expect(page).to     have_css dom_id_selector(@user_1)
    expect(page).to     have_css dom_id_selector(@user_2)
    expect(page).not_to have_css dom_id_selector(@user_3)

    click_link 'Remove filter'

    expect(page).to have_css dom_id_selector(@user_1)
    expect(page).to have_css dom_id_selector(@user_2)
    expect(page).to have_css dom_id_selector(@user_3)
  end
end
