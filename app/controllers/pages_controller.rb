class PagesController < ApplicationController
  # As the pages are all loaded for the navigation already, we don't have to load it on index again
  load_and_authorize_resource except: :index
  provide_optimistic_locking_for :page
  provide_image_pasting_for :page
  before_action :add_breadcrumbs
  before_action :provide_parent_collection, only: [:new, :create, :edit, :update]
  before_action :provide_position_collection, only: [:edit, :update]
  before_action :provide_previous_and_next_page, only: :show
  respond_to :html,
             :atom

  def index
    @pages = PageDecorator.decorate_collection(@pages)
  end

  def show
    @page = @page.decorate
  end

  def create
    @page.creator = current_user
    set_creator_of_new_images(@page.images)
    @page.save

    respond_with @page
  end

  def update
    @page.assign_attributes(page_params)
    set_creator_of_new_images(@page.images)
    @page.save

    respond_with @page
  end

  def destroy
    @page.destroy
    respond_with @page
  end

  private

  def page_params
    params.require(:page).permit(:title,
                                 :navigation_title,
                                 :lead,
                                 :content,
                                 :notes,
                                 :parent_id,
                                 :position,
                                 :lock_version,
                                 images_attributes: image_attributes)
  end

  def add_breadcrumbs
    add_breadcrumb Page.model_name.human(count: :other), pages_path if [:index, :new, :create].include? action_name.to_sym

    unless action_name == 'index'
      @page.ancestors.reverse.each do |ancestor|
        add_breadcrumb ancestor.navigation_title_or_title, page_path(ancestor)
      end
    end

    add_breadcrumb @page.navigation_title_or_title, page_path(@page)      if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),                new_page_path         if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'),               edit_page_path(@page) if [:edit, :update].include?        action_name.to_sym
  end

  def provide_parent_collection
    @parent_collection = @pages.reject { |page| @page.descendants.include? page } - [@page]
  end

  def provide_position_collection
    @position_collection = (@page.siblings + [@page]).sort_by(&:position)
                                                     .map { |sibling| [sibling.title_with_details, sibling.position] }
  end

  def provide_previous_and_next_page
    @previous_page = (index = @pages.index(@page)) == 0 ? nil : @pages[index - 1]
    @next_page     = @pages[@pages.index(@page) + 1]
  end

  def set_creator_of_new_images(images)
    images.select(&:new_record?).each { |image| image.creator = current_user }
  end
end
