require 'rails_helper'

describe 'Listing users' do
  before do
    @user = create :user, :donald
    login_as(create :admin)
  end

  it 'displays users' do
    visit users_path

    expect(page).to have_active_navigation_items 'Users', 'List Users'
    expect(page).to have_breadcrumbs 'Base', 'Users'
    expect(page).to have_headline 'Users'

    within dom_id_selector(@user) do
      expect(page).to have_css '.name a', text: 'donald'
      expect(page).to have_css '.email',  text: 'donald@example.com'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    expect(page).to have_link 'Create User'
  end

  it 'allows to filter users' do
    @user_1 = create :user, name: 'anne'
    @user_2 = create :user, name: 'marianne'
    @user_3 = create :user, name: 'eva'

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
end
