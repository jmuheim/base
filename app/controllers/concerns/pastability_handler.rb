module PastabilityHandler
  extend ActiveSupport::Concern

  module ClassMethods
    def provide_pastability
      after_action :remove_abandoned_pastables, only: [:create, :update],
                                                if: -> { instance_variable_get("@#{controller_name.classify.underscore}").persisted? }
    end
  end

  def images_attributes
    [ :id,
      :file,
      :file_cache,
      :identifier,
      :_destroy
    ]
  end

  def codes_attributes
    [ :id,
      :identifier,
      :title,
      :description,
      :html,
      :css,
      :js,
      :lock_version,
      :_destroy
    ]
  end

  def remove_abandoned_pastables
    resource = instance_variable_get("@#{controller_name.classify.underscore}")

    [:images, :codes].each do |pastables|
      referenced_pastables = []

      resource.textareas_accepting_pastables.each do |textarea|
        resource.send(textarea).to_s.lines.map do |line|
          resource.send(pastables).each do |pastable|
            referenced_pastables << pastable if line =~ /\(@#{pastables.to_s.singularize}-#{pastable.identifier}\)/
          end
        end
      end

      resource.send(pastables).each do |pastable|
        pastable.destroy unless referenced_pastables.include? pastable
      end
    end
  end
end
