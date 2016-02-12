require 'rails_helper'

describe 'Editing user' do
  before { @user = create :user, :donald, about: 'This is some very interesting info about me. I like playing football and reading books. I work as a web developer.' }

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
      fill_in 'user_about', with: 'Some info about me'

      attach_file 'user_avatar', dummy_file_path('other_image.jpg')

      expect {
        click_button 'Update User'
        @user.reload
      } .to  change { @user.name }.to('gustav')
        .and change { File.basename(@user.avatar.to_s) }.to('other_image.jpg')
        .and change { @user.about }.to('Some info about me')
        .and change { @user.unconfirmed_email }.to('new-gustav@example.com')

      expect(page).to have_flash 'User was successfully updated.'
    end

    it "prevents from overwriting other users' changes accidently (caused by race conditions)" do
      visit edit_user_path(@user)

      # Change something in the database...
      expect {
        @user.update_attributes! name:   'interim-name',
                                 about:  "This is some barely interesting info.\n\nI like playing football and reading books.\n\nI don't work as a web developer anymore.",
                                 avatar: File.open(dummy_file_path('image.jpg'))
      }.to change { @user.lock_version }.by 1

      fill_in 'user_name',       with: 'new-name'
      attach_file 'user_avatar', dummy_file_path('other_image.jpg')

      expect {
        click_button 'Update User'
        @user.reload
      }.not_to change { @user }

      expect(page).to have_flash('User meanwhile has been changed. The conflicting fields are: Name, Profile picture, and About.').of_type :alert

      expect(page).to have_css '#stale_attribute_user_name .interim_value', text: 'interim-name'
      expect(page).to have_css '#stale_attribute_user_name .new_value',     text: 'new-name'
      expect(page.html).to include '<del class="differ">interim</del><ins class="differ">new</ins>-name'

      expect(page).to have_css '#stale_attribute_user_about .interim_value', text: 'This is some barely interesting info. I like playing football and reading books. I don\'t work as a web developer anymore.'
      expect(page).to have_css '#stale_attribute_user_about .new_value',     text: 'This is some very interesting info about me. I like playing football and reading books. I work as a web developer.'
      expect(page.html).to include "<p><del class=\"differ\">This is some barely interesting info.</p>\n\n<p>I like playing football and reading books.</p>\n\n<p>I don't work as a web developer anymore.</del><ins class=\"differ\">This is some very interesting info about me. I like playing football and reading books. I work as a web developer.</ins></p>"

      expect(page).to have_css '#stale_attribute_user_avatar .interim_value img[alt="Interim image"]'
      expect(page).to have_css '#stale_attribute_user_avatar .new_value img[alt="New image"]'
      expect(page).to have_css '#stale_attribute_user_avatar .difference', text: 'No diff possible'

      expect {
        click_button 'Update User'
        @user.reload
      } .to  change { @user.name }.to('new-name')
        .and change { File.basename(@user.avatar.to_s) }.to('other_image.jpg')
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
