require 'rails_helper'

describe 'Editing user' do
  before do
    @user = create :user, :donald
    login_as(@user)
  end

  it 'edits the user' do
    visit edit_user_registration_path

    fill_in 'user_name',             with: 'newname'
    fill_in 'user_current_password', with: @user.password
    click_button 'Save'

    expect(page).to have_content 'Your account has been updated successfully.'
  end
end
