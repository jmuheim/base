class User::RegistrationsController < Devise::RegistrationsController
  # Would like to use `before_action :authenticate_user!`, but doesn't work. See http://stackoverflow.com/questions/42938450/devise-cancan-route-get-user-registration-path-isnt-available-how-to-create
  before_action :load_current_user
  load_and_authorize_resource class: 'User', only: :show
  before_action :add_base_breadcrumbs

  private

  def load_current_user
    @user = current_user
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
