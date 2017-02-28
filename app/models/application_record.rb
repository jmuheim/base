class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def resource_class
    self.class.to_s.underscore
  end

  def self.accepts_pasted_images_for(*textareas)
    has_many :images, dependent: :destroy
    accepts_nested_attributes_for :images, allow_destroy: true, reject_if: -> attributes {
      # Ignore lock_version and _destroy when checking for attributes
      attributes.all? { |key, value| %w(_destroy lock_version).include?(key) || value.blank? }
    }

    define_method :textareas_accepting_pasted_images do
      textareas
    end
  end
end
