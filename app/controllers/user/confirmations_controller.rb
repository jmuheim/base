class User::ConfirmationsController < Devise::ConfirmationsController
  before_action :add_breadcrumbs

  private

  def add_breadcrumbs
    add_breadcrumb t('devise.registrations.new.title'), new_user_registration_path
    add_breadcrumb t('devise.confirmations.new.title'), new_user_password_path
  end
end
