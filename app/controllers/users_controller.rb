class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit]
  load_and_authorize_resource
  inherit_resources
  before_filter :add_base_breadcrumbs

  private

  def permitted_params
    params.permit(user: [:name, :email, :avatar, :password, :password_confirmation])
  end

  def add_base_breadcrumbs
    add_breadcrumb User.model_name.human(count: :other), users_path unless action_name == 'index'

    if ['edit', 'update'].include? action_name
      add_breadcrumb @user.name, user_path(@user)
    end
  end
end
