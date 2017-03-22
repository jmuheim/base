# Helps managing uniform navigation.
#
# Relies on Twitter Bootstrap's nav-bar (use `navigation_group` and `navigation_item`); extended using YAMM (https://github.com/geedmo/yamm3) so it allows creating mega menus (use `navigation_mega`).
#
# It assumes there is a `has_breadcrumb?` helper available: if the `target` of the current navigation group or item has a breadcrumb, it's marked up as active (visually using `.active` class, semantically using visually hidden text).

module NavigationHelper
  # Creates a navigation group.
  #
  # Always needs a `group_title` and a `target` URL.
  #
  # The first `navigation_item` of each group is auto-generated; while its `target` URL always is the one of the group, its title depends on the third parameter `item_title`:
  #
  # - If `item_title` is left empty, the first `navigation_item` has the title "Overview"; a visual divider is added below it.
  # - If `item_title` is given a value, the first `navigation_item` has the given value as title.
  #
  # All other `navigation_item`s need to be provided as a block.
  #
  # The group's state is automatically set to active, if ther helper method `has_breadcrumb?` returns `true` for the given `target` URL.
  def navigation_group(group_title, target, item_title = nil, &block)
    group_title = group_title.html_safe

    divider = nil
    if item_title.nil?
      item_title = t('layouts.navigation.overview')
      divider  = content_tag :li, nil, class: 'divider', role: 'decoration'
    end

    has_breadcrumb = has_breadcrumb?(target)
    content_tag :li, class: "dropdown #{:active if has_breadcrumb}" do
      link = link_to '#', class: 'dropdown-toggle', 'data-toggle': 'dropdown', 'aria-expanded': false do
               group_title += content_tag(:span, " (#{t('layouts.navigation.current_group')})", class: 'sr-only') if has_breadcrumb
               group_title + content_tag(:b, nil, class: :caret)
             end

      dropdown = content_tag :ul, class: 'dropdown-menu' do
                   overview = navigation_item item_title, target, active: current_page?(target)
                   overview + divider + capture(self, &block)
                 end

      link + dropdown
    end
  end

  # Creates a navigation item (always needs to be called within a `navigation_group` block).
  #
  # Accepts the following argument combinations:
  #
  # - `title` and `target`
  # - `target` with a block (used as title)
  #
  # The options hash accepts the following keys:
  #
  # - `:active` sets the forces active state (used internally by `navigation_group`)
  #
  # The item's state is automatically set to active, if ther helper method `has_breadcrumb?` returns `true` for the given `target` URL.
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
    options[:active] = has_breadcrumb?(target) if options[:active].nil?
    title += content_tag(:span, " (#{t('layouts.navigation.current_item')})", class: 'sr-only') if options[:active]

    content_tag :li, class: "#{:active if options[:active]}" do
      link_to title, target
    end
  end

  # Creates a navigation mega menu.
  #
  # Always needs a `group_title` and a `target` URL.
  #
  # The mega menu's content needs to be provided as a block.
  #
  # The item's state is automatically set to active, if ther helper method `has_breadcrumb?` returns `true` for the given `target` URL.
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
end