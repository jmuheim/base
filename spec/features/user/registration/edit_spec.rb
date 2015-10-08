require 'rails_helper'

describe 'Editing account' do
  before do
    @user = create :user, :donald
    login_as(@user)
  end

  it 'edits the account' do
    visit edit_user_registration_path

    expect(page).to have_active_navigation_items 'User menu', 'Edit account'
    expect(page).to have_breadcrumbs 'Base', 'Edit account'
    expect(page).to have_headline 'Edit account'

    fill_in 'user_name',  with: 'gustav'
    fill_in 'user_email', with: 'new-gustav@example.com'

    attach_file 'user_avatar', dummy_file_path('other_image.jpg')

    fill_in 'user_password',              with: 'n3wp4ssw0rd'
    fill_in 'user_password_confirmation', with: 'n3wp4ssw0rd'
    fill_in 'user_current_password',      with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
      @user.reload
    } .to  change { @user.name }.to('gustav')
      .and change { @user.avatar.to_s }
      .and change { @user.encrypted_password }
      .and change { @user.unconfirmed_email }.to('new-gustav@example.com')

    expect(page).to have_flash 'You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.'
  end

  it "doesn't change the password if left empty" do
    visit edit_user_registration_path

    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
    }.not_to change { @user.reload.encrypted_password }
  end

  # These specs make sure that the rather tricky image upload things are working as expected
  describe 'avatar upload' do
    it 'caches an uploaded avatar during validation errors' do
      visit edit_user_registration_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Fill in current password
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'image.jpg'
    end

    it 'replaces a cached uploaded avatar with a new one after validation errors' do
      visit edit_user_registration_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Upload another file
      attach_file 'user_avatar', dummy_file_path('other_image.jpg')

      # Fill in current password
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'other_image.jpg'
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit edit_user_registration_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Remove avatar
      check 'user_remove_avatar'

      # Fill in current password
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(User.last.avatar.to_s).to eq ''
    end

    it 'allows to remove an uploaded avatar' do
      @user.update_attributes! avatar: File.open(dummy_file_path('image.jpg'))

      visit edit_user_registration_path
      check 'user_remove_avatar'
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      expect {
        click_button 'Save'

        # Checking upon @user doesn't work, see https://github.com/carrierwaveuploader/carrierwave/issues/1752
      }.to change { File.basename User.last.avatar.to_s }.from('image.jpg').to eq ''

      expect(page).to have_flash 'Your account has been updated successfully.'
    end
  end
end
