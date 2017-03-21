class User::UnlocksController < Devise::UnlocksController
  before_action :add_base_breadcrumbs

  private

  def add_base_breadcrumbs
    add_breadcrumb t('devise.unlocks.new.title'), new_user_password_path
  end
end
