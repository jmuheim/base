class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def resource_class
    self.class.to_s.underscore
  end

  def self.accepts_pastables_for(*textareas)
    [:images, :codes].each do |pastable|
      has_many pastable, dependent: :destroy
      accepts_nested_attributes_for pastable, allow_destroy: true, reject_if: -> attributes {
        # Ignore lock_version and _destroy when checking for attributes
        attributes.all? { |key, value| %w(_destroy lock_version).include?(key) || value.blank? }
      }
    end

    define_method :textareas_accepting_pastables do
      textareas
    end
  end

  # For a translated attribute, if it's not the current language, its name in the current language is returned together with the language abbreviation in brackets. E.g. if the current language is english:
  #
  # - If attribute name is `content_de`, the returned value is "Content (de)"
  # - If attribute name is `content_en`, the returned value is "Content"
  def self.human_attribute_name(attribute_key_name, options = {})
    if respond_to? :translated_attribute_names
      if match = attribute_key_name.match(/^(#{translated_attribute_names.join('|')})_(#{I18n.available_locales.join('|')})$/)
        human_attribute_name = super(match[1], options)
        human_attribute_name += " (#{match[2]})" unless match[2] == I18n.locale.to_s

        return human_attribute_name
      end
    end

    super(attribute_key_name, options)
  end
end
