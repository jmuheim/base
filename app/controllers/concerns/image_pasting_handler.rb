module ImagePastingHandler
  extend ActiveSupport::Concern

  module ClassMethods
    def provide_image_pasting_for(resource_name)
      after_action :remove_abandoned_images, only: [:create, :update], if: -> { instance_variable_get("@#{resource_name}").persisted? }

      define_method :resource_accepting_pasted_images do
        instance_variable_get("@#{resource_name}")
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
    page = resource_accepting_pasted_images
    referenced_images = []

    page.textareas_accepting_pasted_images.each do |textarea|
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
end
