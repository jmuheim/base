require 'spec_helper'

describe MiniHubCell do

  describe '#show' do
    context 'user available' do
      before { @user = build_stubbed(:user) }
      subject { render_cell :mini_hub, :show, user: @user }

      it 'displays "Welcome, <username>"' do
        should have_content "Welcome, #{@user.username}!"
      end

      it "displays a link to edit the user's account" do
        should have_link 'Edit account', href: edit_user_registration_path
      end

      it 'displays a link to log out' do
        should have_link 'Log out', href: destroy_user_session_path
      end
    end
  end

  context 'user not available' do
    subject { render_cell :mini_hub, :show, user: nil }

    it 'displays "Welcome, <username>"' do
      should have_content 'You are not signed in.'
    end

    it 'displays a link to login / register' do
      should have_link 'Login / register', href: new_user_session_path
    end
  end

end
