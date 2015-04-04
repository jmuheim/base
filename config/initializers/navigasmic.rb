# Dirty hack. See https://github.com/jejacks0n/navigasmic/issues/47 and https://github.com/jejacks0n/navigasmic/pull/49.
class AccessibleListBuilder < Navigasmic::Builder::ListBuilder
  def structure_for(label, link = false, options = {}, &block)
    content = ''

    if block_given?
      merge_classes!(options, @config.has_nested_class)
      content = content_tag(@config.group_tag, capture(&block), {class: @config.is_nested_class})
    end

    merge_classes!(options, @config.highlighted_class) if has_active_child?(content)
    label = label_for(label, link, block_given?, options)
    content_tag(@config.item_tag, "#{label}#{content}".html_safe, options)
  end

  # FIXME: This is a very dirty, error-prone hack, because the groups and items are rendered directly to HTML!
  # We should maintain something like a tree structure of groups and items that can really check upon active children.
  def has_active_child?(content)
    content =~ /<li class=".*\b#{@config.highlighted_class}\b.*">/
  end
end

Navigasmic.setup do |config|

  # Defining Navigation Structures:
  #
  # You can define your navigation structures and configure the builders in this initializer.
  #
  # When defining navigation here, it's important to understand that the scope is not the same as the view scope -- and
  # you should use procs where you want things to execute in the view scope.
  #
  # Once you've defined some navigation structures and configured your builders you can render navigation in your views
  # using the `semantic_navigation` view helper.  You can also use the same syntax to define your navigation structures
  # in your views -- and eventually move them here if you want.
  #
  # <%= semantic_navigation :primary %>
  #
  # You can optionally provided a :builder and :config option to the semantic_navigation view helper.
  #
  # <%= semantic_navigation :primary, config: :blockquote %>
  # <%= semantic_navigation :primary, builder: Navigasmic::Builder::MapBuilder %>
  #
  # When defining navigation in your views just pass it a block.
  #
  # <%= semantic_navigation :primary do |n| %>
  #   <% n.item 'About Me' %>
  # <% end %>
  #
  # Here's a basic example:
  config.semantic_navigation :primary do |n|

    n.item 'Home', '/'

    # Groups and Items:
    #
    # Create navigation structures using the `group`, and `item` methods.  You can nest items inside groups or items.
    # In the following example, the "Articles" item will always highlight on the blog/posts controller, and the nested
    # article items will only highlight on those specific pages.  The "Links" item will be disabled unless the user is
    # logged in.
    #
    #n.group 'Blog' do
    #  n.item 'Articles', controller: '/blog/posts' do
    #    n.item 'First Article', '/blog/posts/1'
    #    n.item 'Second Article', '/blog/posts/2', map: {changefreq: 'weekly'}
    #  end
    #  n.item 'Links', controller: '/blog/links', disabled_if: proc{ !logged_in? }
    #end
    #
    # You can hide specific specific items or groups, and here we specify that the "Admin" section of navigation should
    # only be displayed if the user is logged in.
    #
    #n.group 'Admin', hidden_unless: proc{ logged_in? } do
    #  n.item 'Manage Posts', class: 'posts', link_html: {data: {tools: 'posts'}}
    #end
    #
    # Scoping:
    #
    # Scoping is different than in the view here, so we've provided some nice things for you to get around that.  In
    # the above example we just provide '/' as what the home page is, but that may not be correct.  You can also access
    # the path helpers, using a proc, or by proxying them through the navigation object.  Any method called on the
    # navigation scope will be called within the view scope.
    #
    #n.item 'Home', proc{ root_path }
    #n.item 'Home', n.root_path
    #
    # This proxy behavior can be used for I18n as well.
    #
    #n.item n.t('hello'), '/'

  end


  # Setting the Default Builder:
  #
  # By default the Navigasmic::Builder::ListBuilder is used unless otherwise specified.
  #
  # You can change this here:
  config.default_builder = AccessibleListBuilder


  # Configuring Builders:
  #
  # You can change various builder options here by specifying the builder you want to configure and the options you
  # want to change.
  #
  # Changing the default ListBuilder options:
  #config.builder Navigasmic::Builder::ListBuilder do |builder|
  #  builder.wrapper_class = 'semantic-navigation'
  #end

  config.builder AccessibleListBuilder do |builder|
    # Set the nav and nav-pills css (you can also use 'nav nav-tabs') -- or remove them if you're using this inside a
    # navbar.
    builder.wrapper_class = 'nav navbar-nav'

    # Set the classed for items that have nested items, and that are nested items.
    builder.has_nested_class = 'dropdown'
    builder.is_nested_class = 'dropdown-menu'

    # For dropdowns to work you'll need to include the bootstrap dropdown js
    # For groups, we adjust the markup so they'll be clickable and be picked up by the javascript.
    builder.label_generator = proc do |label, options, has_link, has_nested|
      is_active = options[:class] =~ /\b#{builder.highlighted_class}\b/

      if !has_nested || has_link
        label << "<span class='sr-only'> (#{t('layouts.navigation.current_item')})</span>".html_safe if is_active
        label
      else
        label << "<span class='sr-only'> (#{t('layouts.navigation.current_group')})</span>".html_safe if is_active
        link_to("#{label}<b class='caret'></b>".html_safe, '#', class: 'dropdown-toggle', data: {toggle: 'dropdown'}, aria: {expanded: false})
      end
    end

    # For items, we adjust the links so they're '#', and do the same as for groups.  This allows us to use more complex
    # highlighting rules for dropdowns.
    builder.link_generator = proc do |label, link, link_options, has_nested|
      if has_nested
        link = '#'
        label << "<b class='caret'></b>"
        link_options.merge!(class: 'dropdown-toggle', data: {toggle: 'dropdown'})
      end
      link_to(label, link, link_options)
    end
  end
end
