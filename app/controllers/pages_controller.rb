class PagesController < ApplicationController
  before_action :set_view
  helper_method :default_headline

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

  def default_headline(options = {})
    t "pages.#{@view}.title"
  end
end
