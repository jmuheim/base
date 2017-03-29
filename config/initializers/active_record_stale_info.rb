class ActiveRecord::Base
  class StaleInfo < Struct.new(:resource, :attribute, :human_attribute_name, :input_id, :type, :value_before, :value_after)
    attr_accessor :resource, :attribute, :human_attribute_name, :input_id, :type, :value_before, :value_after

    def initialize(options)
      options.each do |key, value|
        self.send "#{key}=", value
      end
    end
  end

  def stale_info
    return @stale_info if @stale_info

    @stale_info = []

    @stale_info += stale_info_for(self, model_name.to_s.underscore) if stale?

    nested_attributes_options.each do |association, value|
      send(association).each_with_index do |resource, i|
        prefix = "#{model_name.to_s.underscore}_#{association}_attributes_#{i}"
        @stale_info += stale_info_for(resource, prefix, nested: true) if resource.respond_to?(:lock_version) && resource.stale?
      end
    end

    @stale_info
  end

  def stale?
    # TODO: At the time being, base64 strings (mount_base64_uploader) seem to always be marked as changed, even when they're not, see https://github.com/lebedev-yury/carrierwave-base64/issues/23.
    persisted? && changed? && lock_version != self.class.find(id).lock_version
  end

  private

  def stale_info_for(resource, prefix, options = {})
    options.reverse_merge! nested: false
    model_name_suffix = options[:nested] ? " (#{resource.class.model_name.human} ##{resource.id})" : ''

    resource.changes.map do |attribute, change|
      unless ['updated_at', 'lock_version'].include? attribute
        StaleInfo.new resource:             resource,
                      attribute:            attribute,
                      human_attribute_name: "#{resource.class.human_attribute_name(attribute)}#{model_name_suffix}",
                      input_id:             "#{prefix}_#{attribute}",
                      type:                 resource.class.columns_hash[attribute].type,
                      value_before:         change[0],
                      value_after:          change[1]
      end
    end.compact
  end
end
