require 'rails_helper'

describe 'Editing user' do
  before { @user = create :user, :donald }

  context 'as a guest' do
    it 'does not grant permission to edit a user' do
      visit edit_user_path(@user)

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'signed in as user' do
    before { login_as(@user) }

    it 'grants permission to edit own user' do
      visit edit_user_path(@user)

      expect(page).to have_status_code 200
    end
  end

  context 'signed in as admin' do
    before do
      admin = create :admin, :scrooge
      login_as(admin)
    end

    it 'grants permission to edit other user' do
      visit edit_user_path(@user)

      expect(page).to have_active_navigation_items 'Users'
      expect(page).to have_breadcrumbs 'Base', 'Users', 'donald', 'Edit'
      expect(page).to have_headline 'Edit donald'

      fill_in 'user_name',  with: 'gustav'
      fill_in 'user_email', with: 'new-gustav@example.com'

      attach_file 'user_avatar', dummy_file_path('other_image.jpg')

      expect {
        click_button 'Update User'
        @user.reload
      } .to  change { @user.name }.to('gustav')
        .and change { @user.avatar.to_s }
        .and change { @user.unconfirmed_email }.to('new-gustav@example.com')

      expect(page).to have_flash 'User was successfully updated.'
    end


    # These specs make sure that the rather tricky image upload things are working as expected
    describe 'avatar upload' do
      it 'caches an uploaded avatar during validation errors' do
        visit edit_user_path @user

        # Upload a file
        attach_file 'user_avatar', dummy_file_path('image.jpg')

        # Trigger validation error
        fill_in 'user_name', with: ''
        click_button 'Update'
        expect(page).to have_flash('User could not be updated.').of_type :alert

        # Make validations pass
        fill_in 'user_name', with: 'john'

        click_button 'Update'

        expect(page).to have_flash 'User was successfully updated.'

        # TODO: Why does @user.reload work here, but somewhere else it doesn't??
        expect(File.basename(@user.reload.avatar.to_s)).to eq 'image.jpg'
      end

      it 'replaces a cached uploaded avatar with a new one after validation errors' do
        visit edit_user_path @user

        # Upload a file
        attach_file 'user_avatar', dummy_file_path('image.jpg')

        # Trigger validation error
        fill_in 'user_name', with: ''
        click_button 'Update'
        expect(page).to have_flash('User could not be updated.').of_type :alert

        # Upload another file
        attach_file 'user_avatar', dummy_file_path('other_image.jpg')

        # Make validations pass
        fill_in 'user_name', with: 'john'

        click_button 'Update'

        expect(page).to have_flash 'User was successfully updated.'
        expect(File.basename(@user.reload.avatar.to_s)).to eq 'other_image.jpg'
      end

      it 'allows to remove a cached uploaded avatar after validation errors' do
        visit edit_user_path @user

        # Upload a file
        attach_file 'user_avatar', dummy_file_path('image.jpg')

        # Trigger validation error
        fill_in 'user_name', with: ''
        click_button 'Update'
        expect(page).to have_flash('User could not be updated.').of_type :alert

        # Remove avatar
        check 'user_remove_avatar'

        # Make validations pass
        fill_in 'user_name', with: 'john'

        click_button 'Update'

        expect(page).to have_flash 'User was successfully updated.'
        expect(@user.reload.avatar.to_s).to eq ''
      end

      it 'allows to remove an uploaded avatar' do
        @user.update_attributes! avatar: File.open(dummy_file_path('image.jpg'))

        visit edit_user_path @user
        check 'user_remove_avatar'

        expect {
          click_button 'Update'
        }.to change { File.basename User.find(@user.id).avatar.to_s }.from('image.jpg').to eq '' # Here @user.reload works! Not the same as in https://github.com/carrierwaveuploader/carrierwave/issues/1752!

        expect(page).to have_flash 'User was successfully updated.'
      end
    end
  end
end
