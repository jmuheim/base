require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :init_guest_user, unless: -> { user_signed_in? }
  attr_reader :guest_user

  # Guest accounts: in order to fix the problem with ajax requests you have to turn off protect_from_forgery for the
  # controller action with the ajax request.
  # See https://github.com/plataformatec/devise/wiki/How-To:-Create-a-guest-user)
  # skip_before_filter :verify_authenticity_token, only: [:name_of_your_action]

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
    @guest_user = @current_user = User.guests.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound
    session[:guest_user_id] = nil
    init_guest_user
  end

  def create_guest_user
    user = User.create! guest: true
    session[:guest_user_id] = user.id
    user
  end
end
