require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def configure_permitted_parameters
    devise_parameter_sanitizer.for :sign_up do |u|
      u.permit :username, :email, :password, :password_confirmation, :remember_me
    end

    devise_parameter_sanitizer.for :sign_in do |u|
      u.permit :username, :email, :password, :remember_me
    end

    devise_parameter_sanitizer.for :account_update do |u|
      u.permit :username, :email, :password, :password_confirmation, :current_password
    end
  end
end
