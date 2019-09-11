require 'rails_helper'

describe UsersController do
  describe 'role param' do
    context 'logged in as user' do
      before do
        @user = create :user
        login_as @user
      end

      it { should_not permit(:role).for(:update, params: {id: @user.id, user: {role: 'x'}}).on :user }
    end

    context 'logged in as admin' do
      before do
        @admin = create :user, :admin
        login_as @admin
      end

      it { should_not permit(:role).for(:update, params: {id: @admin.id,        user: {role: 'x'}}).on :user }
      it { should     permit(:role).for(:update, params: {id: create(:user).id, user: {role: 'x'}}).on :user }
    end
  end

  describe 'disabled param' do
    context 'logged in as user' do
      before do
        @user = create :user
        login_as @user
      end

      it { should_not permit(:disabled).for(:update, params: {id: @user.id, user: {disabled: 'x'}}).on :user }
    end

    context 'logged in as admin' do
      before do
        @admin = create :user, :admin
        login_as @admin
      end

      it { should_not permit(:disabled).for(:update, params: {id: @admin.id,        user: {disabled: 'x'}}).on :user }
      it { should     permit(:disabled).for(:update, params: {id: create(:user).id, user: {disabled: 'x'}}).on :user }
    end
  end
end
