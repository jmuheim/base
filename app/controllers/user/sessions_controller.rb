class User::SessionsController < Devise::SessionsController
  before_action :add_base_breadcrumbs

  private

  def add_base_breadcrumbs
    add_breadcrumb t('devise.sessions.new.title'), new_user_session_path
    add_breadcrumb t('devise.passwords.new.title'), new_user_password_path
  end
end
