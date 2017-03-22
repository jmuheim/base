module BreadcrumbsHelper
  def render_breadcrumbs
    @breadcrumbs.map do |breadcrumb|
      content_tag :li do
        link_to breadcrumb[:target] do
          truncate breadcrumb[:title], length: 30, separator: ' '
        end
      end
    end.join.html_safe
  end

  def navigation_item(*args, &block)
    options = args.extract_options!

    if args.size == 2
      title  = args[0]
      target = args[1]
    elsif args.size == 1 && block_given?
      title  = capture(self, &block)
      target = args[0]
    else
      raise "You must pass as arguments either a title and a target, or only a target plus a block!"
    end

    title = title.html_safe
    active = has_breadcrumb?(target) if active.nil?
    title += content_tag(:span, " (#{t('layouts.navigation.current_item')})", class: 'sr-only') if active

    content_tag :li, class: "#{:active if active}" do
      link_to title, target
    end
  end

  def navigation_mega(group_title, target, &block)
    group_title = group_title.html_safe

    content_tag :li, class: "dropdown #{:active if has_breadcrumb?(target)}" do
      active = current_page?(target)

      link = link_to '#', class: 'dropdown-toggle', 'data-toggle': 'dropdown', 'aria-expanded': false do
               group_title += content_tag(:span, " (#{t('layouts.navigation.current_group')})", class: 'sr-only') if active
               group_title + content_tag(:b, nil, class: :caret)
             end

      dropdown = content_tag :div, class: 'dropdown-menu yamm-content' do
                   capture(self, &block)
                 end

      link + dropdown
    end
  end

  def navigation_group(group_title, target, item_title = nil, &block)
    group_title = group_title.html_safe

    divider = nil
    if item_title.nil?
      item_title = t('layouts.navigation.overview')
      divider  = content_tag :li, nil, class: 'divider', role: 'decoration'
    end

    content_tag :li, class: "dropdown #{:active if has_breadcrumb?(target)}" do
      active = current_page?(target)

      link = link_to '#', class: 'dropdown-toggle', 'data-toggle': 'dropdown', 'aria-expanded': false do
               group_title += content_tag(:span, " (#{t('layouts.navigation.current_group')})", class: 'sr-only') if active
               group_title + content_tag(:b, nil, class: :caret)
             end

      dropdown = content_tag :ul, class: 'dropdown-menu' do
                   overview = navigation_item item_title, target, active: true
                   overview + divider + capture(self, &block)
                 end

      link + dropdown
    end
  end
end