module ApplicationHelper
  def icon(name, content = nil)
    content_tag :span, class: ['glyphicon', "glyphicon-#{name}"] do
      content_tag :span, class: 'hide-text' do
        content || name.to_s.titleize
      end
    end
  end

  # TODO: Add spec!
  def flag(name, content = nil)
    content_tag :span, class: ['glyphicon', "bfh-flag-#{name.upcase}"] do
      content_tag :span, class: 'hide-text' do
        content || name.to_s.titleize
      end
    end
  end

  # TODO: Add spec!
  def current_locale_flag
    case I18n.locale
    when :en
      :gb
    when :de
      :de
    end
  end

  # TODO: Add spec!
  def home_link_class
    classes = ['navbar-brand']
    classes << 'active' if request.path == root_path
    classes
  end

  # TODO: Add spec!
  def active_class_for(language)
    'active' if language == I18n.locale
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
  def user_avatar
    if current_user.avatar?
      image_tag(current_user.avatar.url(:thumb), class: 'avatar')
    else
      icon :user
    end
  end

  def container_for(object, options = {})
    tag = options[:tag] || 'div'

    content_tag tag, id: dom_id(object), class: dom_class(object) do
      yield
    end
  end

  def page_heading(*args)
    options = args.extract_options!
    heading = args[0]
    raise "You can't provide both a heading and options!" if heading && options.any?
    @page_heading = heading.nil? ? default_page_heading(options) : heading
  end

  def page_title
    parts = []
    parts += flash.map { |key, value| "#{t "flash.#{key}"}: #{value}" } if flash.any?
    parts << (@page_heading or raise 'No page heading provided! Be sure to call #page_heading first.')
    parts.join ' '
  end

  def default_page_heading(options = {})
    t '.title', options
  end
end
