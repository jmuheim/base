# This controller is only necessary for devise_scope :user { get 'user' => 'registrations#show' }
class RegistrationsController < Devise::RegistrationsController
  # before_filter :authenticate_user! # Doesn't seem to work, see https://github.com/plataformatec/devise/issues/3349#issuecomment-88604326
  before_filter :load_and_authorize_current_user
  respond_to :html

  # We can't rely on CanCanCan, as it relies on a params[:id] which isn't present, and by manually setting @user, the authorization isn't performed anymore. See https://github.com/ryanb/cancan/issues/452#issuecomment-88614091.
  def load_and_authorize_current_user
    @user = current_user
    authorize!(params[:action].to_sym, @user)
  end
end
