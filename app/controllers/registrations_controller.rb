class RegistrationsController < Devise::RegistrationsController
  # TODO: load_and_authorize_resource

  def show
    @user = current_user
  end
end
