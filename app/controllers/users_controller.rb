class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  load_and_authorize_resource
  before_action :add_base_breadcrumbs
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

  def add_base_breadcrumbs
    add_breadcrumb User.model_name.human(count: :other), users_path

    if ['show', 'edit', 'update'].include? action_name
      add_breadcrumb @user.name, user_path(@user)
      @last_breadcrumb = t 'actions.edit'
    end

    if ['new', 'create'].include? action_name
      @last_breadcrumb = t 'actions.new'
    end
  end
end
