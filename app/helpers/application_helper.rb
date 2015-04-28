module ApplicationHelper
  def icon(name, content = nil)
    content_tag :span, class: ['glyphicon', "glyphicon-#{name}"] do
      content_tag :span, content, class: 'sr-only' if content
    end
  end

  def flag(name, content = nil)
    content_tag :span, class: ['glyphicon', "bfh-flag-#{name.upcase}"] do
      content_tag :span, content, class: 'sr-only' if content
    end
  end

  def current_locale_flag
    case I18n.locale
    when :en
      :gb
    else
      I18n.locale
    end
  end

  def home_link_class
    classes = ['navbar-brand']
    classes << 'active' if request.path == root_path
    classes
  end

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
  def user_avatar(content)
    if user_signed_in? && current_user.avatar?
      image_tag(current_user.avatar.url(:thumb), class: 'avatar', alt: content)
    else
      icon :user, content
    end
  end

  def container_for(object, options = {})
    tag = options[:tag] || 'div'

    content_tag tag, id: dom_id(object), class: dom_class(object) do
      yield
    end
  end

  # See https://github.com/jejacks0n/navigasmic/issues/52
  def active_if_controller?(controller_to_check)
    :active if controller_name.to_s == controller_to_check.to_s
  end
end
