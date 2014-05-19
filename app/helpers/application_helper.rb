module ApplicationHelper
  def icon(name, content = nil)
    content_tag :span, class: ['glyphicon', "glyphicon-#{name}"] do
      content_tag :span, class: 'hide-text' do
        content || name.to_s.titleize
      end
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

  def language_selector_locales
    [:en_GB, :de_DE]
  end

  def current_language_selector_locale
    case I18n.locale
    when :en
      :en_GB
    when :de
      :de_DE
    end
  end
end
