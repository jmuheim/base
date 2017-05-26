module PastabilityHandler
  extend ActiveSupport::Concern

  module ClassMethods
    def provide_pastability_for(resource_name)
      after_action :remove_abandoned_pastables, only: [:create, :update],
                                                if: -> { instance_variable_get("@#{resource_name}").persisted? }

      define_method :resource_accepting_pastables do
        instance_variable_get("@#{resource_name}")
      end
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
    page = resource_accepting_pastables

    [:images, :codes].each do |pastables|
      referenced_pastables = []

      page.textareas_accepting_pastables.each do |textarea|
        page.send(textarea).to_s.lines.map do |line|
          page.send(pastables).each do |pastable|
            referenced_pastables << pastable if line =~ /\(@#{pastables.to_s.singularize}-#{pastable.identifier}\)/
          end
        end
      end

      page.send(pastables).each do |pastable|
        pastable.destroy unless referenced_pastables.include? pastable
      end
    end
  end
end
