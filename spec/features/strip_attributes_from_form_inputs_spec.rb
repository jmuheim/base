require 'rails_helper'

describe 'Stripping trailing whitespace and nullify on form input' do
  it 'strips trailing whitespace on form input' do
    @user = create :user
    login_as(@user)

    visit edit_user_registration_path

    fill_in 'user_name', with: " some user   \n "
    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
      @user.reload
    }.to change { @user.name }.from('User test name').to 'some user'
  end

  it 'nullifies empty values on form input' do
    @user = create :user
    login_as(@user)

    visit edit_user_registration_path

    fill_in 'user_about', with: "\n    \n   "
    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
      @user.reload
    }.to change { @user.about }.from('User test about').to nil
  end
end
