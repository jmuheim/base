class PagesController < ApplicationController
  before_filter :set_view

  def show
    render @view
  end

  protected

  def set_view
    @view = params[:view]
  end

  # TODO: Add spec!
  def body_css_classes
    super << @view
  end
end
