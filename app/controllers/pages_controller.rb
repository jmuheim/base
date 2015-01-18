class PagesController < ApplicationController
  def show
    render params[:view]
  end

  protected

  # TODO: Add spec!
  def body_css_classes
    super << params[:view]
  end
end
