class PagesController < ApplicationController
  load_and_authorize_resource
  provide_optimistic_locking_for :page
  before_action :add_base_breadcrumbs
  respond_to :html

  def create
    @page.save
    respond_with @page
  end

  def update
    @page.update(page_params)
    respond_with @page
  end

  def destroy
    @page.destroy
    respond_with @page
  end

  private

  def page_params
    params.require(:page).permit(:title,
                                 :content,
                                 :notes,
                                 :lock_version)
  end

  def add_base_breadcrumbs
    add_breadcrumb page.model_name.human(count: :other), pages_path unless action_name == 'index'

    if ['edit', 'update'].include? action_name
      add_breadcrumb @page.name_with_details, page_path(@page)
      @last_breadcrumb = t 'actions.edit'
    end

    if ['new', 'create'].include? action_name
      @last_breadcrumb = t 'actions.new'
    end
  end

  # before_action :set_view
  # helper_method :default_headline
  #
  # def show
  #   render @view
  # end
  #
  # protected
  #
  # def set_view
  #   @view = params[:view]
  # end
  #
  # # TODO: Add spec!
  # def body_css_classes
  #   super << @view
  # end
  #
  # def default_headline(options = {})
  #   t "pages.#{@view}.title"
  # end
end
