require 'spec_helper'

describe 'Creating user' do
  before do
    @admin = create :admin, :scrooge
    login_as(@admin)
  end

  it 'creates a user' do
    visit new_user_path

    fill_in 'user_name',                  with: 'newname' # TODO: Don't use input's ID, use label text everywhere! Addendum: really?? Shouldn't we just rely on SimpleForm displaying labels anyways?
    fill_in 'user_email',                 with: 'somemail@example.com'
    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'
    click_button 'Save'

    expect(page).to have_content 'User was successfully created.'
  end
end
