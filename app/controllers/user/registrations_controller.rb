class User::RegistrationsController < Devise::RegistrationsController
  # before_action :authenticate_user! # Doesn't seem to work, see https://github.com/plataformatec/devise/issues/3349#issuecomment-88604326
  # I really think that Devise's RegistrationsController should authenticate the :show action the same way it does for the :edit action (e.g. when visiting /user/edit as non logged in user, it redirects to root page and displays a warning).
  before_action :load_and_authorize_current_user
  before_action :add_base_breadcrumbs

  private

  # We can't rely on CanCanCan, as it relies on a params[:id] which isn't present, and by manually setting @user, the authorization isn't performed anymore. See https://github.com/ryanb/cancan/issues/452#issuecomment-88614091.
  def load_and_authorize_current_user
    @user = current_user
    authorize!(params[:action].to_sym, @user)
  end

  def add_base_breadcrumbs
    add_breadcrumb current_user.name, user_registration_path if ['show', 'edit', 'update'].include? action_name

    if ['edit', 'update'].include? action_name
      add_breadcrumb t('devise.registrations.edit.title'), new_user_registration_path
    end

    if ['new', 'create'].include? action_name
      add_breadcrumb t('devise.registrations.new.title'), new_user_registration_path
    end
  end
end
