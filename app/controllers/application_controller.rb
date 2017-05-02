require 'application_responder'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include BreadcrumbsHandler
  include OptimisticLockingHandler
  include ImagePastingHandler

  helper :image_gallery

  helper_method :body_css_classes

  self.responder = ApplicationResponder

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :ensure_locale
  before_action :provide_pages
  before_action :provide_root_pages
  before_action :set_paper_trail_whodunnit

  def default_url_options(options = {})
    {locale: I18n.locale}
  end

  protected

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [ :name, :email, :about,
                                                        :password, :password_confirmation,
                                                        :remember_me,
                                                        :avatar, :avatar_cache, :remove_avatar,
                                                        :curriculum_vitae,
                                                        :curriculum_vitae_cache,
                                                        :remove_curriculum_vitae
                                                      ]

    devise_parameter_sanitizer.permit :sign_in, keys: [ :name, :email, :password,
                                                        :remember_me
                                                      ]

    devise_parameter_sanitizer.permit :account_update, keys: [ :name, :email, :about,
                                                               :password, :password_confirmation,
                                                               :current_password, :avatar,
                                                               :avatar_cache, :remove_avatar,
                                                               :curriculum_vitae,
                                                               :curriculum_vitae_cache,
                                                               :remove_curriculum_vitae
                                                             ]
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
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

  # This is needed on every page to display the navigation. Always use this variable instead of executing `Page.collection_tree` again, to prevent heavy and redundant DB queries!
  def provide_pages
    @pages = []
    Page.walk_tree do |page, level|
      page.define_singleton_method(:level) { level }

      @pages << page
    end
  end

  def provide_root_pages
    @root_pages = @pages.select { | page | page.level == 0 }
  end
end
