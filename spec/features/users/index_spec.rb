require 'rails_helper'

describe 'Listing users' do
  before do
    @user = create :user, :donald
    @admin = create :admin

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
      expect(page).to have_css '.name a', text: 'donald'
      expect(page).to have_css '.email',  text: 'donald@example.com'

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
    click_button 'Filter'

    expect(page).to     have_css dom_id_selector(@user_1)
    expect(page).to     have_css dom_id_selector(@user_2)
    expect(page).not_to have_css dom_id_selector(@user_3)

    click_link 'Remove filter'

    expect(page).to have_css dom_id_selector(@user_1)
    expect(page).to have_css dom_id_selector(@user_2)
    expect(page).to have_css dom_id_selector(@user_3)
  end

  it 'marks recurrent occurences of identical roles' do
    @another_admin = create :admin, name: 'another admin', email: 'another-admin@test.com'
    @another_user = create :user, name: 'another user', email: 'another-user@test.com'

    visit users_path

    within dom_id_selector(@user) do
      expect(page).to have_css '.roles .first_occurrence', text: ''
    end

    within dom_id_selector(@admin) do
      expect(page).to have_css '.roles .first_occurrence', text: 'admin'
    end

    within dom_id_selector(@another_admin) do
      expect(page).to have_css '.roles .recurrent_occurrence', text: 'admin'
    end

    within dom_id_selector(@another_user) do
      expect(page).to have_css '.roles .first_occurrence', text: ''
    end
  end
end
