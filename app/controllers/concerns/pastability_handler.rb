module PastabilityHandler
  extend ActiveSupport::Concern

  module ClassMethods
    def provide_pastability_for(resource_name)
      [:images, :codes].each do |pastable|
        after_action "remove_abandoned_#{pastable}", only: [:create, :update],
                                                     if: -> { instance_variable_get("@#{resource_name}").persisted? }

        define_method :resource_accepting_pastables do
          instance_variable_get("@#{resource_name}")
        end
      end
    end
  end

  def image_attributes
    [ :id,
      :file,
      :file_cache,
      :identifier,
      :_destroy
    ]
  end

  def remove_abandoned_images
    page = resource_accepting_pastables
    referenced_images = []

    page.textareas_accepting_pastables.each do |textarea|
      page.send(textarea).to_s.lines.map do |line|
        page.images.each do |image|
          referenced_images << image if line =~ /\(@image-#{image.identifier}\)/
        end
      end
    end

    page.images.each do |image|
      image.destroy unless referenced_images.include? image
    end
  end

  def remove_abandoned_codes
    # TODO!
  end
end
