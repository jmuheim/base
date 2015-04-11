require 'rails_helper'

describe 'File upload' do
  it 'allows to upload a file' do
    pending # See http://stackoverflow.com/questions/29564354/carrierwave-setting-remove-previously-stored-files-after-update-to-true-breaks

    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path

    attach_file 'user_avatar', dummy_file_path('other_image.jpg')
    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
    }.to change { File.basename(@user.reload.avatar.to_s) }.from('image.jpg').to 'other_image.jpg'
  end

  it 'displays a preview of an uploaded file' do
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path

    expect(page).to have_css '.user_avatar .thumbnail img[src$="/image.jpg"]'
  end

  it 'displays a preview of an uploaded file (from the temporary cache) after a re-display of the form' do
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path

    attach_file 'user_avatar', dummy_file_path('other_image.jpg')
    fill_in 'user_current_password', with: '' # Empty password triggers validation error and form re-display

    click_button 'Save'

    expect(page).to have_css '.user_avatar .thumbnail img[src^="/uploads/tmp/"]'
  end

  it 'uses an uploaded file (from the temporary cache) after a re-display and then successful submit of the form' do
    pending # See http://stackoverflow.com/questions/29564354/carrierwave-setting-remove-previously-stored-files-after-update-to-true-breaks
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path

    attach_file 'user_avatar', dummy_file_path('other_image.jpg')

    fill_in 'user_current_password', with: '' # Empty password triggers validation error and form re-display
    click_button 'Save'
    expect(page).to have_css '.user_avatar .thumbnail img[src^="/uploads/tmp/"]'

    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
    }.to change { File.basename(@user.reload.avatar.to_s) }.from('image.jpg').to 'other_image.jpg'
  end

  it 'allows to remove a file' do
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path
    expect(page).to have_css 'img.avatar'

    check 'user_remove_avatar'

    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    click_button 'Save'

    # Notice: it would be nice to check upon change of @user.avatar or something like that, but didn't succeed with this...
    expect(page).not_to have_css 'img.avatar'
  end

  it 'limits the size of an uploaded image' do
    @user = create :user
    login_as(@user)

    visit edit_user_registration_path

    attach_file 'user_avatar', dummy_file_path('big_image.jpg')

    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    click_button 'Save'

    expect(page).to have_content 'is too big (should be at most 15 KB)'
  end
end
