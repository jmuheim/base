class PagesController < ApplicationController
  load_and_authorize_resource
  provide_optimistic_locking_for :page
  before_action :add_base_breadcrumbs
  before_action :provide_parent_collection, only: [:new, :create, :edit, :update]
  before_action :provide_position_collection, only: [:edit, :update]
  respond_to :html

  def index
    @pages = Page.collection_tree
  end

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
                                 :navigation_title,
                                 :lead,
                                 :content,
                                 :notes,
                                 :parent_id,
                                 :position,
                                 :lock_version)
  end

  def add_base_breadcrumbs
    add_breadcrumb Page.model_name.human(count: :other), pages_path if [:new, :create].include? action_name.to_sym

    unless action_name == 'index'
      @page.ancestors.reverse.each do |ancestor|
        add_breadcrumb ancestor.navigation_title_or_title, page_path(ancestor)
      end
    end

    if ['edit', 'update'].include? action_name
      add_breadcrumb @page.navigation_title_or_title, page_path(@page)
      @last_breadcrumb = t 'actions.edit'
    end

    if ['new', 'create'].include? action_name
      @last_breadcrumb = t 'actions.new'
    end

    @last_breadcrumb = @page.navigation_title_or_title if action_name == 'show'
  end

  def provide_parent_collection
    @parent_collection = @page.collection_tree_without_self_and_descendants
  end

  def provide_position_collection
    @position_collection = (@page.siblings + [@page]).sort_by(&:position)
                                                     .map { |sibling| [sibling.title, sibling.position] }
  end
end
