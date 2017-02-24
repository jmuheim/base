class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.accepts_pasted_images_for(*textareas)
    has_many :images, dependent: :destroy
    accepts_nested_attributes_for :images, allow_destroy: true, reject_if: -> attributes {
      # Ignore lock_version and _destroy when checking for attributes
      attributes.all? { |key, value| %w(_destroy lock_version).include?(key) || value.blank? }
    }

    define_method :textareas_accepting_pasted_images do
      textareas
    end

    textareas.each do |textarea|
      define_method "#{textarea}_with_referenced_images" do
        send(textarea).to_s.lines.map do |line|
          images.each do |image|
            # TODO: Da wird gar nicht nach dem ganzen Bild gesucht!
            line.gsub! /\(#{image.identifier}\)/, "(#{image.file.url})"
          end

          line
        end.join
      end
    end
  end
end
