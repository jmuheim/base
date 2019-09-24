module PastabilityHandler
  extend ActiveSupport::Concern

  module ClassMethods
    def provide_pastability
      after_action :remove_abandoned_pastables, only: [:create, :update],
                                                if: -> { resource.persisted? }
    end
  end

  def images_attributes
    [ :id,
      :file,
      :file_cache,
      :identifier,
      :remove_file,
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

  def resource
    instance_variable_get("@#{controller_name.classify.underscore}")
  end

  def remove_abandoned_pastables
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

  def assign_creator_to_new_pastables
    [:images, :codes].each do |pastables|
      resource.send(pastables).select(&:new_record?).each { |pastable| pastable.creator = current_user }
    end
  end

  # TODO: Only when the codepen was updated!
  def assign_codepen_data_to_codes
    resource.codes.each do |code|
      # Some meta data is available through CodePen's JSON API
      json = JSON.load(open("https://codepen.io/api/oembed?url=#{code.pen_url}&format=json"))
      code.title         = json['title']
      code.thumbnail_url = json['thumbnail_url']

      # HTML, CSS, and JavaScript must be imported through the pen's URL with proper extension appended
      [:html, :css, :js].each do |format|
        code.send "#{format}=", open("#{code.pen_url}.#{format}").read
      end
    end
  end
end
