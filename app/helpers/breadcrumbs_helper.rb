# For more details, see `BreadcrumbsHandler`.

module BreadcrumbsHelper
  def render_breadcrumbs
    @breadcrumbs.map do |breadcrumb|
      content_tag :li, class: 'breadcrumb-item' do
        link_to breadcrumb[:target] do
          truncate breadcrumb[:title], length: 30, separator: ' '
        end
      end
    end.join.html_safe
  end
end
