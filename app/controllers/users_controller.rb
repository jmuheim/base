class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit]
  load_and_authorize_resource
  before_filter :add_base_breadcrumbs
  provide_optimistic_locking_for :user

  def index
    @q = @users.ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def create
    if @user.save
      redirect_to @user, notice: t('flash.actions.create.notice', resource_name: User.model_name.human)
    else
      flash.now[:alert] = t('flash.actions.create.alert', resource_name: User.model_name.human)
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: t('flash.actions.update.notice', resource_name: User.model_name.human)
    else
      flash.now[:alert] = t('flash.actions.update.alert', resource_name: User.model_name.human)
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: t('flash.actions.destroy.notice', resource_name: User.model_name.human)
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :avatar,
                                 :avatar_cache,
                                 :remove_avatar,
                                 :about,
                                 :password,
                                 :password_confirmation,
                                 :lock_version)
  end

  def add_base_breadcrumbs
    add_breadcrumb User.model_name.human(count: :other), users_path unless action_name == 'index'

    if ['edit', 'update'].include? action_name
      add_breadcrumb @user.name, user_path(@user)
      @last_breadcrumb = t 'actions.edit'
    end

    if ['new', 'create'].include? action_name
      @last_breadcrumb = t 'actions.new'
    end
  end
end
