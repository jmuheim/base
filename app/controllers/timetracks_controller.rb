class TimetracksController < ApplicationController
  load_and_authorize_resource
  before_action :add_breadcrumbs
  respond_to :html

  def create
    @timetrack.save
    respond_with @timetrack
  end

  def update
    @timetrack.update_attributes(timetrack_params)
    respond_with @timetrack
  end

  def destroy
    @timetrack.destroy
    respond_with @timetrack
  end

  private

  def timetrack_params
    params.require(:timetrack).permit(:name,
                                      :description,
                                      :work_time,
                                      :bill_time)
  end

  def add_breadcrumbs
    add_breadcrumb Timetrack.model_name.human(count: :other), timetracks_path

    add_breadcrumb @timetrack.name,   timetrack_path(@timetrack)      if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),  new_timetrack_path              if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'), edit_timetrack_path(@timetrack) if [:edit, :update].include?        action_name.to_sym
  end
end
