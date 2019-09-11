require 'rails_helper'

RSpec.describe "users/edit" do
  describe 'role select' do
    context 'not logged in' do
      it 'is not shown' do
        assign :user, User.new
        render
        expect(rendered).not_to have_selector('select#user_role')
      end
    end

    context 'logged in' do
      context 'as user' do
        before do
          @user = create :user
          login_as @user
        end

        it 'is shown as disabled' do
          assign :user, @user
          render
          expect(rendered).to have_selector('select#user_role[disabled]')
        end
      end

      context 'as admin' do
        before do
          @admin = create :user, :admin
          login_as @admin
        end

        it 'is shown as disabled (for own user)' do
          assign :user, @admin
          render
          expect(rendered).to have_selector('select#user_role[disabled]')
        end

        it 'is shown as enabled (for other user)' do
          assign :user, create(:user)
          render
          expect(rendered).to have_selector('select#user_role:not([disabled])')
        end
      end
    end
  end
end
