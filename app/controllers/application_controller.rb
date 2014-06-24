require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :init_guest_user, unless: -> { user_signed_in? }
  attr_reader :guest_user

  before_action :set_locale

  before_filter :ensure_locale

  def default_url_options(options = {})
    {locale: I18n.locale}
  end

  # Guest accounts: in order to fix the problem with ajax requests you have to turn off protect_from_forgery for the
  # controller action with the ajax request.
  # See https://github.com/plataformatec/devise/wiki/How-To:-Create-a-guest-user)
  # skip_before_action :verify_authenticity_token, only: [:name_of_your_action]

  protected

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def configure_permitted_parameters
    devise_parameter_sanitizer.for :sign_up do |u|
      u.permit :name, :email, :password, :password_confirmation, :remember_me
    end

    devise_parameter_sanitizer.for :sign_in do |u|
      u.permit :name, :email, :password, :remember_me
    end

    devise_parameter_sanitizer.for :account_update do |u|
      u.permit :name, :email, :password, :password_confirmation, :current_password
    end
  end

  private

  def user_signed_in?
    current_user.present? ? !current_user.guest? : super
  end

  def init_guest_user
    @current_user = User.guests.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound
    remove_guest_user
    init_guest_user
  end

  def create_guest_user
    user = User.create do |user|
      user.guest = true
      user.skip_confirmation!
    end

    session[:guest_user_id] = user.id
    user
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def remove_guest_user
    User.find(session[:guest_user_id]).delete rescue ActiveRecord::RecordNotFound
  ensure
    session[:guest_user_id] = nil
  end

  # We always want an explicit locale to be available in the URL, like `/de/users/123`.
  def ensure_locale
    return if params[:controller] == 'rails_admin/main' # rails_admin passes the locale as GET param, see https://github.com/sferik/rails_admin/issues/2000

    unless Rails.env.test? # In controller specs, the default locale isn't available. As we don't want to manually specify a locale for every request in controller specs, we don't enforce a locale in test environment. This isn't optimal, as we it prevents us from actually testing this before filter, but it has to be okay for the moment. More infos here: https://github.com/rspec/rspec-rails/issues/255
      redirect_to root_path if params[:locale].blank?
    end
  end
end
