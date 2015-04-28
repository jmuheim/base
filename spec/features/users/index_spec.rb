require 'rails_helper'

describe 'Listing users' do
  before do
    @user = create :user, :donald
    login_as(create :admin)
  end

  it 'displays users' do
    visit users_path

    expect(page).to have_content 'Users'

    within dom_id_selector(@user) do
      expect(page).to have_css '.name a', text: 'donald'
      expect(page).to have_css '.email',  text: 'donald@example.com'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    expect(page).to have_link 'Create User'
  end
end
