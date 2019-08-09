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
      expect(page).to have_css '.name a',   text: 'User test name'
      expect(page).to have_css '.email',    text: 'user@example.com'
      expect(page).to have_css '.disabled', text: 'No'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    within 'div.actions' do
      expect(page).to have_css 'h2', text: 'Actions'
      expect(page).to have_link 'Create User'
    end
  end

  it 'allows to filter users' do
    @user_1 = create :user, name: 'anne', email: 'anne@example.com', disabled: true
    @user_2 = create :user, name: 'marianne', email: 'marianne@example.com'
    @user_3 = create :user, name: 'eva', email: 'eva@example.com'

    visit users_path

    expect(page).to have_css dom_id_selector(@user_1)
    expect(page).to have_css dom_id_selector(@user_2)
    expect(page).to have_css dom_id_selector(@user_3)

    fill_in 'q_name_cont', with: 'anne'
    select 'Yes', from: 'q_disabled_true'
    click_button 'Filter'

    expect(page).to     have_css dom_id_selector(@user_1)
    expect(page).not_to have_css dom_id_selector(@user_2)
    expect(page).not_to have_css dom_id_selector(@user_3)

    click_link 'Remove filter'

    expect(page).to have_css dom_id_selector(@user_1)
    expect(page).to have_css dom_id_selector(@user_2)
    expect(page).to have_css dom_id_selector(@user_3)
  end

  it 'applies the disabled=false filter when navigating through the menu' do
    @user_1 = create :user, name: 'anne', email: 'anne@example.com'
    @user_2 = create :user, name: 'marianne', email: 'marianne@example.com', disabled: true

    visit root_path

    within '#meta_navigation' do
      click_link 'List of Users'
    end

    expect(page).to     have_css dom_id_selector(@user_1)
    expect(page).not_to have_css dom_id_selector(@user_2)

    expect(page).to have_link 'Remove filter'
    expect(page).to have_select('q_disabled_true', selected: 'No')
  end
end
