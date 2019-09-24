require 'rails_helper'

describe UsersController do
  describe 'role param' do
    context 'logged in as user' do
      before do
        @user = create :user
        login_as @user
      end

      it { should_not permit(:role).for(:create, params: {              user: {name: 'whatever'}}).on :user }
      it { should_not permit(:role).for(:update, params: {id: @user.id, user: {name: 'whatever'}}).on :user }
    end

    context 'logged in as admin' do
      before do
        @admin = create :user, :admin
        login_as @admin
      end

      it { should     permit(:role).for(:create, params: {               user: {name: 'whatever'}}).on :user }
      it { should_not permit(:role).for(:update, params: {id: @admin.id, user: {name: 'whatever'}}).on :user }

      it { should permit(:role).for(:create, params: {                      user: {name: 'whatever'}}).on :user }
      it { should permit(:role).for(:update, params: {id: create(:user).id, user: {name: 'whatever'}}).on :user }
    end
  end

  describe 'disabled param' do
    context 'logged in as user' do
      before do
        @user = create :user
        login_as @user
      end

      it { should_not permit(:disabled).for(:create, params: {              user: {name: 'whatever'}}).on :user }
      it { should_not permit(:disabled).for(:update, params: {id: @user.id, user: {name: 'whatever'}}).on :user }
    end

    context 'logged in as admin' do
      before do
        @admin = create :user, :admin
        login_as @admin
      end

      it { should     permit(:disabled).for(:create, params: {               user: {name: 'whatever'}}).on :user }
      it { should_not permit(:disabled).for(:update, params: {id: @admin.id, user: {name: 'whatever'}}).on :user }

      it { should permit(:disabled).for(:create, params: {                      user: {name: 'whatever'}}).on :user }
      it { should permit(:disabled).for(:update, params: {id: create(:user).id, user: {name: 'whatever'}}).on :user }
    end
  end
end
