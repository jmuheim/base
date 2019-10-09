module ApplicationHelper
  def icon(name, *args)
    options = args.extract_options!
    content = args[0]

    content_tag :span, class: ['fa', "fa-#{name}"] do
      sr_only content if content
    end
  end

  def sr_only(content)
    content_tag :span, content, class: 'sr-only'
  end

  def flag(name, content = nil)
    content_tag :span, class: ['fa', "bfh-flag-#{name.upcase}"] do
      sr_only content if content
    end
  end

  def yes_or_no(bool)
    I18n.t(bool.to_s)
  end

  def yes_or_no_icon(bool)
    icon((bool ? :ok : :remove), yes_or_no(bool))
  end

  def locale_flag(locale)
    locale == :en ? :gb : locale
  end

  def current_locale_flag
    locale_flag I18n.locale
  end

  def home_link_class
    classes = ['navbar-brand']
    classes << 'active' if request.path == root_path
    classes
  end

  def active_class_for(locale)
    'active' if locale == I18n.locale
  end

  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  # TODO: Add spec!
  def user_avatar(content)
    if user_signed_in? && current_user.avatar?
      image_tag(current_user.avatar.url(:thumb), class: 'avatar', alt: '')
    else
      icon :user
    end + sr_only(content)
  end

  def container_for(object, options = {})
    tag = options[:tag] || 'div'

    content_tag tag, id: dom_id(object), class: dom_class(object) do
      yield
    end
  end

  # This doesn't take into account create and update actions (when having validation errors), see http://stackoverflow.com/questions/42234081/rails-why-does-create-update-action-point-to-the-same-url-like-the-index-action.
  # See https://github.com/jejacks0n/navigasmic/issues/52
  def active_if_controller?(*controllers_to_check)
    :active if controllers_to_check.map(&:to_s).include? controller_name.to_s
  end

  def recurring_string?(element, namespace)
    @recurrent_elements ||= {}

    klass = if element == @recurrent_elements[namespace]
              :recurrent_occurrence
            else
              @recurrent_elements[namespace] = element
              :first_occurrence
            end

    content_tag :span, element, class: klass
  end

  def complete_internal_references(resource, attribute_name)
    resource.send(attribute_name).to_s.lines.map do |line|
      line.gsub!(/\[(.*?)\]\((@(.+?)-(.+?))\)/) do
        caption = $1
        url     = $2
        type    = $3
        id      = $4
        data    = []

        case type
        when 'page'
          if page = Page.find_by_id(id)
            data << ".#{type}"
            url = Rails.application.routes.url_helpers.page_path(I18n.locale, page) # This is very ugly! :-(

            if caption.empty?
              caption = page.title
            elsif caption != page.title
              data << "title=\"#{page.title}\""
            end
          end
        when 'image'
          if image = resource.images.find_by_identifier(id)
            data << ".#{type}"
            url = image.file.url
          end
        when 'code'
          if code = resource.codes.find_by_identifier(id)
            data << ".#{type}"

            if caption.empty?
              caption = code.title
            elsif caption != code.title
              data << "title=\"#{code.title}\""
            end

            # TODO: Adding the thumbnail only works well in block links! Inline links should have a font awesome code icon instead.
            caption = "**#{caption}**![](#{code.thumbnail_url})"

            url = code.pen_url
          end
        end

        data_string = data.empty? ? nil : "{#{data.join ' '}}"
        "[#{caption}](#{url})#{data_string}"
      end

      line
    end.join
  end

  def replace_placeholders(text, placeholders = {})
    placeholders.inject(text) do |content, placeholder|
      content.gsub "[#{placeholder.first}]", placeholder.last.to_s
    end
  end
end
