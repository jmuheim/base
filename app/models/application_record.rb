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

      define_method :textareas_accepting_pastables do
        textareas
      end
    end
  end
end
