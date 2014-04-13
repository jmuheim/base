class UsersController < ApplicationController
  load_and_authorize_resource
  inherit_resources
  respond_to :html

  private

  def permitted_params
    params.permit(user: [:name, :email, :password, :password_confirmation])
  end
end
