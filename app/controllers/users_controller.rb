require 'update_lock'

class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!, only: [:new, :edit]
  before_filter :add_base_breadcrumbs

  rescue_from ActiveRecord::StaleObjectError do
    prepare_conflicted_stuff(@user)
  end

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

  def prepare_conflicted_stuff(resource)
    flash.now[:alert] = t(
      'flash.actions.update.stale',
      resource_name: resource.class.model_name.human,
      stale_info:    t('flash.actions.update.stale_attributes_list',
        stale_attributes: resource.stale_info.map { |info| info.human_attribute_name }.to_sentence,
        count:            resource.stale_info.size
      )
    )

    # Set lock version to current value in DB so when saving again (after manually solving the conflicts), no StaleObjectError is thrown anymore
    resource.stale_info.each do |stale_info|
      stale_info.resource.lock_version = stale_info.resource.class.find(stale_info.resource.id).lock_version
    end

    render :edit, status: :conflict
  end
end
