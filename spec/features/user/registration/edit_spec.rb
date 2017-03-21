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
    expect(page).to have_breadcrumbs 'Base', 'donald', 'Edit account'
    expect(page).to have_headline 'Edit account'

    fill_in 'user_name',  with: 'gustav'
    fill_in 'user_email', with: 'new-gustav@example.com'
    fill_in 'user_about', with: 'Some info about me'


    attach_file 'user_curriculum_vitae', dummy_file_path('other_document.txt')
    fill_in 'user_avatar', with: base64_other_image[:data]

    fill_in 'user_password',              with: 'n3wp4ssw0rd'
    fill_in 'user_password_confirmation', with: 'n3wp4ssw0rd'
    fill_in 'user_current_password',      with: 's3cur3p@ssw0rd'

    expect(page).to have_css 'h2', text: 'Cancel my account'

    expect {
      click_button 'Save'
      @user.reload
    } .to  change { @user.name }.to('gustav')
      .and change { File.basename(@user.avatar.to_s) }.to('avatar.png')
      .and change { File.basename(@user.curriculum_vitae.to_s) }.to('other_document.txt')
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

  describe 'avatar upload' do
    it 'caches an uploaded avatar during validation errors' do
      visit edit_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(File.basename(@user.reload.avatar.to_s)).to eq 'avatar.png'
    end

    it 'replaces a cached uploaded avatar with a new one after validation errors', js: true do
      visit edit_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Upload another file
      scroll_by(0, 10000) # Otherwise the footer overlaps the element and results in a Capybara::Poltergeist::MouseEventFailed, see http://stackoverflow.com/questions/4424790/cucumber-capybara-scroll-to-bottom-of-page
      click_link 'Click to paste another Profile picture image'
      fill_in 'user_avatar',  with: base64_other_image[:data]

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(@user.reload.avatar.file.size).to eq base64_other_image[:size]
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit edit_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Remove avatar
      check 'user_remove_avatar'

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(@user.reload.avatar.to_s).to eq ''
    end

    it 'allows to remove an uploaded avatar' do
      @user.update_attributes! avatar: File.open(dummy_file_path('image.jpg'))

      visit edit_user_registration_path

      check 'user_remove_avatar'

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      expect {
        click_button 'Save'
      }.to change { File.basename User.find(@user.id).avatar.to_s }.from('image.jpg').to eq '' # Here @user.reload works! Not the same as in https://github.com/carrierwaveuploader/carrierwave/issues/1752!

      expect(page).to have_flash 'Your account has been updated successfully.'
    end
  end

  describe 'curriculum_vitae upload' do
    it 'caches an uploaded curriculum_vitae during validation errors' do
      visit edit_user_registration_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(File.basename(User.find(@user.id).curriculum_vitae.to_s)).to eq 'document.txt'
    end

    it 'replaces a cached uploaded curriculum_vitae with a new one after validation errors' do
      visit edit_user_registration_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Upload another file
      attach_file 'user_curriculum_vitae', dummy_file_path('other_document.txt')

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(File.basename(User.find(@user.id).curriculum_vitae.to_s)).to eq 'other_document.txt'
    end

    it 'allows to remove a cached uploaded curriculum_vitae after validation errors' do
      visit edit_user_registration_path

      # Upload a file
      attach_file 'user_curriculum_vitae', dummy_file_path('document.txt')

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Remove curriculum_vitae
      check 'user_remove_curriculum_vitae'

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(User.find(@user.id).curriculum_vitae.to_s).to eq ''
    end

    it 'allows to remove an uploaded curriculum_vitae' do
      @user.update_attributes! curriculum_vitae: File.open(dummy_file_path('document.txt'))

      visit edit_user_registration_path
      check 'user_remove_curriculum_vitae'
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      expect {
        click_button 'Save'
      }.to change { File.basename User.find(@user.id).curriculum_vitae.to_s }.from('document.txt').to eq '' # Checking upon @user doesn't work, see https://github.com/carrierwaveuploader/carrierwave/issues/1752

      expect(page).to have_flash 'Your account has been updated successfully.'
    end
  end
end
