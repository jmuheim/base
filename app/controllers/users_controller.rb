class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit]
  load_and_authorize_resource
  inherit_resources
  respond_to :html

  private

  def permitted_params
    params.permit(user: [:name, :email, :avatar, :password, :password_confirmation])
  end
end
