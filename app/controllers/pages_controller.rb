class PagesController < ApplicationController
  # As the pages are all loaded for the navigation already, we don't have to load it on index again
  load_and_authorize_resource except: :index
  provide_optimistic_locking
  provide_pastability
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
    assign_creator_to_new_pastables
    assign_codepen_data_to_codes
    @page.save

    respond_with @page
  end

  def update
    @page.assign_attributes(page_params)
    assign_creator_to_new_pastables
    assign_codepen_data_to_codes
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
                                 images_attributes: images_attributes,
                                 codes_attributes: codes_attributes)
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

  def assign_creator_to_new_pastables
    [:images, :codes].each do |pastables|
      @page.send(pastables).select(&:new_record?).each { |pastable| pastable.creator = current_user }
    end
  end

  # TODO: Only when the codepen was updated!
  def assign_codepen_data_to_codes
    @page.codes.each do |code|
      # Some meta data is available through CodePen's JSON API
      json = JSON.load(open("https://codepen.io/api/oembed?url=#{code.pen_url}&format=json"))
      code.title         = json['title']
      code.thumbnail_url = json['thumbnail_url']

      # HTML, CSS, and JavaScript must be imported through the pen's URL with proper extension appended
      [:html, :css, :js].each do |format|
        code.send "#{format}=", open("#{code.pen_url}.#{format}").read
      end
    end
  end
end
