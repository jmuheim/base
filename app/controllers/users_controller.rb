class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :add_breadcrumbs
  provide_optimistic_locking
  respond_to :html

  def index
    @q = @users.ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def create
    # Make captcha mechanism pass automatically (only needed for new registrations, not when creating a user manually).
    # This is ugly, see https://github.com/kiskolabs/humanizer/issues/50.
    @user.humanizer_question_id = '16'
    @user.humanizer_answer      = '5'

    @user.save
    respond_with @user
  end

  def update
    @user.update user_params
    respond_with @user
  end

  def destroy
    @user.destroy
    respond_with @user
  end

  private

  def user_params
    permitted_keys = [:name,
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
                      :lock_version]

    auth_object = @user || User.new # See https://stackoverflow.com/questions/57873176/
    permitted_keys << :role     if can? :edit_role,     auth_object
    permitted_keys << :disabled if can? :edit_disabled, auth_object

    params.require(:user).permit permitted_keys
  end

  def add_breadcrumbs
    add_breadcrumb User.model_name.human(count: :other), users_path(params: user_index_params)

    add_breadcrumb @user.name,        user_path(@user)      if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),  new_user_path         if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'), edit_user_path(@user) if [:edit, :update].include?        action_name.to_sym
  end
end
