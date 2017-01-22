require 'rails_helper'

describe 'Editing account' do
  before do
    @user = create :user, :donald
    login_as(@user)
  end

  it 'edits the account' do
    visit edit_user_registration_path

    expect(page).to have_title 'Edit account - Base'
    expect(page).to have_active_navigation_items 'User menu', 'Edit account'
    expect(page).to have_breadcrumbs 'Base', 'Edit account'
    expect(page).to have_headline 'Edit account'

    fill_in 'user_name',  with: 'gustav'
    fill_in 'user_email', with: 'new-gustav@example.com'
    fill_in 'user_about', with: 'Some info about me'

    attach_file 'user_avatar', dummy_file_path('other_image.jpg')

    fill_in 'user_password',              with: 'n3wp4ssw0rd'
    fill_in 'user_password_confirmation', with: 'n3wp4ssw0rd'
    fill_in 'user_current_password',      with: 's3cur3p@ssw0rd'

    expect(page).to have_css 'h2', text: 'Cancel my account'

    expect {
      click_button 'Save'
      @user.reload
    } .to  change { @user.name }.to('gustav')
      .and change { File.basename(@user.avatar.to_s) }.to('other_image.jpg')
      .and change { @user.about }.to('Some info about me')
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

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(File.basename(User.find(@user.id).avatar.to_s)).to eq 'image.jpg'
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

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(File.basename(User.find(@user.id).avatar.to_s)).to eq 'other_image.jpg'
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

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(User.find(@user.id).avatar.to_s).to eq ''
    end

    it 'allows to remove an uploaded avatar' do
      @user.update_attributes! avatar: File.open(dummy_file_path('image.jpg'))

      visit edit_user_registration_path
      check 'user_remove_avatar'
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      expect {
        click_button 'Save'
      }.to change { File.basename User.find(@user.id).avatar.to_s }.from('image.jpg').to eq '' # Checking upon @user doesn't work, see https://github.com/carrierwaveuploader/carrierwave/issues/1752

      expect(page).to have_flash 'Your account has been updated successfully.'
    end
  end
end
