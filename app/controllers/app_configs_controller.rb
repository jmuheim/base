class AppConfigsController < ApplicationController
  load_and_authorize_resource
  provide_optimistic_locking
  before_action :add_breadcrumbs
  respond_to :html

  def update
    @app_config.assign_attributes(setting_params)
    @app_config.save

    respond_with @project, @app_config
  end

  def destroy
    @app_config.destroy
    respond_with @project, @app_config
  end

  private

  def setting_params
    params.require(:app_config)
          .permit(:organisation_name,
                  :organisation_abbreviation,
                  :organisation_url,
                  :lock_version)
  end

  def add_breadcrumbs
    add_breadcrumb AppConfig.model_name.human, app_config_path

    add_breadcrumb t('actions.edit'), edit_app_config_path(@app_config) if [:edit, :update].include?        action_name.to_sym
  end
end
