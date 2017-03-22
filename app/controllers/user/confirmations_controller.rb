class User::ConfirmationsController < Devise::ConfirmationsController
  before_action :add_base_breadcrumbs

  private

  def add_base_breadcrumbs
    add_breadcrumb t('devise.registrations.new.title'), new_user_registration_path
    add_breadcrumb t('devise.confirmations.new.title'), new_user_password_path
  end
end
