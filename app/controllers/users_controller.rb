class UsersController < ApplicationController
  load_and_authorize_resource
  inherit_resources
  respond_to :html

  before_filter :set_user, only: :show

  private

  def set_user
    @user = current_user
  end

  def permitted_params
    params.permit(user: [:name, :email, :password, :password_confirmation])
  end
end
