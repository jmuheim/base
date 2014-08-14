require 'rails_helper'

describe 'Admin' do
  it 'allows access to the admin area (to an admin user)' do
    @admin = create :admin
    sign_in_as @admin

    visit rails_admin_path

    expect(page).to have_content 'Site Administration'
  end

  it 'prevents access to the admin area (to a normal user)' do
    @user = create :user
    sign_in_as @user

    visit rails_admin_path

    expect(page).to have_content '403 - Forbidden'
  end
end
