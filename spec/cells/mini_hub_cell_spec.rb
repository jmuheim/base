require 'spec_helper'

describe MiniHubCell do

  describe '#show' do
    context 'user logged in' do
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

  context 'user not logged in (guest)' do
    before { @guest = build_stubbed(:guest) }
    subject { render_cell :mini_hub, :show, user: @guest }

    it 'displays "Welcome, guest"' do
      should have_content 'Welcome, guest!'
    end

    it 'displays a link to login' do
      should have_link 'Sign in', href: new_user_session_path
    end

    it 'displays a link to register' do
      should have_link 'Sign up', href: new_user_registration_path
    end
  end

end
