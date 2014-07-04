require 'spec_helper'

describe 'Edit account' do
  before do
    @user = create :user, :donald
    login_as(@user)
  end

  it 'edits the account' do
    visit edit_user_registration_path

    fill_in 'user_name', with: 'gustav'
    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
    }.to change { @user.reload.name }.from('donald').to 'gustav'
  end
end
