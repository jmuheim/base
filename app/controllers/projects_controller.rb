class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :add_breadcrumbs
  respond_to :html

  def create
    @project.save
    respond_with @project
  end

  def update
    @project.update_attributes(project_params)
    respond_with @project
  end

  def destroy
    @project.destroy
    respond_with @project
  end

  private

  def project_params
    params.require(:project).permit(:name,
                                    :description)
  end

  def add_breadcrumbs
    add_breadcrumb Project.model_name.human(count: :other), projects_path

    add_breadcrumb @project.name,     project_path(@project)      if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),  new_project_path            if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'), edit_project_path(@project) if [:edit, :update].include?        action_name.to_sym
  end
end
