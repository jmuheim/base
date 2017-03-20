module BreadcrumbsHandler
  extend ActiveSupport::Concern

  included do
    helper_method :has_breadcrumb?
  end

  module ClassMethods
  end

  # I don't know whether there is a better way than overriding this...
  def initialize
    super
    @breadcrumbs = []
  end

  def add_breadcrumb(title, target)
    @breadcrumbs << {title: title, target: target}
  end

  # private

  def has_breadcrumb?(target)
    @breadcrumbs.map { |breadcrumb| breadcrumb[:target] == target }.any?
  end
end
