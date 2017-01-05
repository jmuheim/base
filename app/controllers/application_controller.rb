require 'application_responder'

class ApplicationController < ActionController::Base
  helper :image_gallery

  helper_method :body_css_classes

  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :ensure_locale

  def default_url_options(options = {})
    {locale: I18n.locale}
  end

  protected

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [ :name, :email, :about,
                                                        :password, :password_confirmation,
                                                        :remember_me, :avatar,
                                                        :avatar_cache, :remove_avatar
                                                      ]

    devise_parameter_sanitizer.permit :sign_in, keys: [ :name, :email, :password,
                                                        :remember_me
                                                      ]

    devise_parameter_sanitizer.permit :account_update, keys: [ :name, :email, :about,
                                                               :password, :password_confirmation,
                                                               :current_password, :avatar,
                                                               :avatar_cache, :remove_avatar
                                                             ]
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # We always want an explicit locale to be available in the URL, like `/de/users/123`.
  def ensure_locale
    return if params[:controller] == 'rails_admin/main' # rails_admin passes the locale as GET param, see https://github.com/sferik/rails_admin/issues/2000

    unless Rails.env.test? # In controller specs, the default locale isn't available. As we don't want to manually specify a locale for every request in controller specs, we don't enforce a locale in test environment. This isn't optimal, as we it prevents us from actually testing this before filter, but it has to be okay for the moment. More infos here: https://github.com/rspec/rspec-rails/issues/255
      redirect_to root_path if params[:locale].blank?
    end
  end

  # TODO: Move to helpers (http://stackoverflow.com/questions/29397658) and add spec!
  def body_css_classes
    [controller_name, action_name]
  end

  def self.provide_optimistic_locking_for(resource_name)
    rescue_from ActiveRecord::StaleObjectError do
      render_edit_with_stale_info(instance_variable_get("@#{resource_name}"))
    end
  end
  rescue_from ActiveRecord::StaleObjectError do
    render_edit_with_stale_info(@user)
  end

  def render_edit_with_stale_info(resource)
    flash.now[:alert] = t(
      'flash.actions.update.stale',
      resource_name: resource.class.model_name.human,
      stale_info:    t('flash.actions.update.stale_attributes_list',
        stale_attributes: resource.stale_info.map { |info| info.human_attribute_name }.to_sentence,
        count:            resource.stale_info.size
      )
    )

    # Set lock version to current value in DB so when saving again (after manually solving the conflicts), no StaleObjectError is thrown anymore
    resource.stale_info.each do |stale_info|
      stale_info.resource.lock_version = stale_info.resource.class.find(stale_info.resource.id).lock_version
    end

    render :edit, status: :conflict
  end
end
