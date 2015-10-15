require 'update_lock'

class UsersController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new, :edit]
  load_and_authorize_resource
  include UpdateLock
  before_filter :add_base_breadcrumbs

  private

  def permitted_params
    params.permit(user: [:name,
                         :email,
                         :avatar,
                         :avatar_cache,
                         :remove_avatar,
                         :about,
                         :password,
                         :password_confirmation,
                         :lock_version
                       ])
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
