class PagesController < ApplicationController
  load_and_authorize_resource
  provide_optimistic_locking_for :page
  before_action :add_base_breadcrumbs
  after_action :remove_abandoned_images, only: [:create, :update], if: -> { @page.persisted? }
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
    params.require(:page).permit( :title,
                                  :navigation_title,
                                  :content,
                                  :notes,
                                  :lock_version,
                                  images_attributes: [ :id,
                                                       :file,
                                                       :file_cache,
                                                       :identifier,
                                                       :_destroy
                                                    ]
                                )
  end

  def remove_abandoned_images
    # TODO: Nach Bildern suchen mit Identifier, welche in der DB nicht existieren!
  end

  def add_base_breadcrumbs
    add_breadcrumb Page.model_name.human(count: :other), pages_path if [:new, :create].include? action_name.to_sym

    if ['edit', 'update'].include? action_name
      add_breadcrumb @page.navigation_title, page_path(@page)
      @last_breadcrumb = t 'actions.edit'
    end

    if ['new', 'create'].include? action_name
      @last_breadcrumb = t 'actions.new'
    end

    @last_breadcrumb = @page.navigation_title if action_name == 'show'
  end
end
