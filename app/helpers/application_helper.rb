module ApplicationHelper
  def icon(name, content = nil)
    content_tag :span, class: ['glyphicon', "glyphicon-#{name}"] do
      content_tag :span, class: 'hide-text' do
        content || name.to_s.titleize
      end
    end
  end

  def flag(name, content = nil)
    content_tag :span, class: ['glyphicon', "bfh-flag-#{name.upcase}"] do
      content_tag :span, class: 'hide-text' do
        content || name.to_s.titleize
      end
    end
  end

  def current_locale_flag
    case I18n.locale
    when :en
      :gb
    when :de
      :de
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
end
