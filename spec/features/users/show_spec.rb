require 'rails_helper'

describe 'Showing user' do
  before do
    @user = create :user, :donald, :with_avatar
    login_as(create :admin)
  end

  it 'displays a user' do
    visit user_path(@user)

    expect(page).to have_content 'donald'

    within dom_id_selector(@user) do
      expect(page).to have_css '.email', text: 'donald@example.com'
      expect(page).to have_css '.avatar img[alt="donald"]'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end
end
