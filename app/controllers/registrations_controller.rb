class RegistrationsController < Devise::RegistrationsController
  def show
    @user = current_user
  end
end
