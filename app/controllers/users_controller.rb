class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  load_and_authorize_resource
  before_action :add_breadcrumbs
  provide_optimistic_locking_for :user
  respond_to :html

  def index
    @q = @users.ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def create
    @user.save
    respond_with @user
  end

  def update
    @user.update(user_params)
    respond_with @user
  end

  def destroy
    @user.destroy
    respond_with @user
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :avatar,
                                 :avatar_cache,
                                 :remove_avatar,
                                 :curriculum_vitae,
                                 :curriculum_vitae_cache,
                                 :remove_curriculum_vitae,
                                 :about,
                                 :password,
                                 :password_confirmation,
                                 :lock_version)
  end

  def add_breadcrumbs
    add_breadcrumb User.model_name.human(count: :other), users_path

    add_breadcrumb @user.name,        user_path(@user)      if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),  new_user_path         if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'), edit_user_path(@user) if [:edit, :update].include?        action_name.to_sym
  end
end
