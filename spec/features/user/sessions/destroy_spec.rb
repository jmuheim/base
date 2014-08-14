require 'rails_helper'

describe 'Signing out' do
  before do
    @user = create :user, :donald
    login_as(@user)
  end

  it 'signs the user out' do
    visit destroy_user_session_path

    expect(page).to have_content 'Signed out successfully.'
    expect(page).not_to have_link 'Login'
  end
end
