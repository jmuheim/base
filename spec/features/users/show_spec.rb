require 'rails_helper'

describe 'Showing users' do
  before do
    @user = create :user, :donald
    login_as(create :admin)
  end

  it 'displays a user' do
    visit user_path(@user)

    expect(page).to have_content 'donald'
    within dom_id_selector(@user) do
      expect(page).to have_content 'donald'
      expect(page).to have_content 'donald@example.com'
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end
end
