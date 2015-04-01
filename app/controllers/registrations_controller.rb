class RegistrationsController < Devise::RegistrationsController
  # Doesn't seem to work, see https://github.com/plataformatec/devise/issues/3349#issuecomment-88604326
  # before_filter :authenticate_user!
  # Or should it better be load_and_authorize_resource?

  def show
    @user = current_user
  end
end
