require 'rails_helper'

describe 'Authorization' do
  it 'displays a "403 - Forbidden" message on permission denied' do
    @user = create :user

    visit edit_user_path @user

    expect(page).to have_content '403 - Forbidden'
  end
end
