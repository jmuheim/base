class ActiveRecord::Base
  class StaleInfo # TODO: Struct?!
    attr_accessor :resource, :attribute, :human_attribute_name, :input_id, :type, :interim_value, :new_value, :difference

    def initialize(options)
      self.resource             = options[:resource]
      self.attribute            = options[:attribute]
      self.human_attribute_name = options[:human_attribute_name]
      self.input_id             = options[:input_id]
      self.type                 = options[:type]
      self.interim_value        = options[:interim_value]
      self.new_value            = options[:new_value]
      self.difference           = options[:difference]
    end
  end

  def stale_info
    return @stale_info if @stale_info

    @stale_info = []
    @stale_info += stale_info_for(self, model_name.to_s.underscore) if persisted? && changed?

    nested_attributes_options.each do |association, value|
      send(association).each_with_index do |resource, i|
        prefix = "#{model_name.to_s.underscore}_#{association}_attributes_#{i}"
        @stale_info += stale_info_for(resource, prefix, nested: true) if resource.persisted? && resource.changed?
      end
    end

    @stale_info
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
                      interim_value:        change[0],
                      new_value:            change[1]
      end
    end.compact
  end
end

module UpdateLock
  def update
    # TODO: Would be nice to be able to make sure that lock_version is a permitted parameter!
    if params[resource_instance_name][:lock_version].blank?
      raise ActiveRecord::MissingAttributeError, 'Lock version missing'
    end

    super
  rescue ActiveRecord::StaleObjectError
    flash.now[:alert] = t(
      'flash.actions.update.stale',
      resource_name: resource.class.model_name.human,
      stale_info:    t('flash.actions.update.stale_attributes_list',
        stale_attributes: resource.stale_info.map { |info| info.human_attribute_name }.to_sentence,
        count:            resource.stale_info.size
      )
    )

    # Set lock version to current value in DB so when saving again (after manually solving the conflicts), no StaleObjectError is thrown anymore
    resource.stale_info.each do |stale_info|
      stale_info.resource.lock_version = stale_info.resource.class.find(stale_info.resource.id).lock_version
    end

    render :edit, status: :conflict
  end
end
