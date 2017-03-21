class User::PasswordsController < Devise::PasswordsController
  before_action :add_base_breadcrumbs

  private

  def add_base_breadcrumbs
    add_breadcrumb t('devise.passwords.new.title'), new_user_password_path
  end
end
