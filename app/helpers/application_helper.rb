module ApplicationHelper
  def icon(name, content = nil)
    content_tag :span, class: ['glyphicon', "glyphicon-#{name}"] do
      content_tag :span, class: 'hide-text' do
        content || name.to_s.titleize
      end
    end
  end

  def active_class_for(language)
    'active' if language == I18n.locale
  end
end
