require 'rails_helper'

describe 'Editing account' do
  before do
    @user = create :user, :donald
    login_as(@user)
    visit edit_user_registration_path
  end

  it 'edits the account' do
    fill_in 'user_name',  with: 'gustav'
    fill_in 'user_email', with: 'new-gustav@example.com'

    attach_file 'user_avatar', dummy_file_path('other_image.jpg')

    fill_in 'user_password',              with: 'n3wp4ssw0rd'
    fill_in 'user_password_confirmation', with: 'n3wp4ssw0rd'
    fill_in 'user_current_password',      with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
    }.to change { @user.reload.name }.from('donald').to 'gustav'
  end

  context 'new password' do
    it "doesn't change the password if left empty" do
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      expect {
        click_button 'Save'
      }.not_to change { @user.reload.encrypted_password }
    end

    it "changes the password if provided" do
      fill_in 'user_password',              with: 'n3wp4ssw0rd'
      fill_in 'user_password_confirmation', with: 'n3wp4ssw0rd'
      fill_in 'user_current_password',      with: 's3cur3p@ssw0rd'

      expect {
        click_button 'Save'
      }.to change { @user.reload.encrypted_password }
    end
  end
end
