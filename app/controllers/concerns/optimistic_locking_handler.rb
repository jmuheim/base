module OptimisticLockingHandler
  extend ActiveSupport::Concern

  module ClassMethods
    def provide_optimistic_locking_for(resource_name)
      rescue_from ActiveRecord::StaleObjectError do
        render_edit_with_stale_info(instance_variable_get("@#{resource_name}"))
      end
    end
  end

  def render_edit_with_stale_info(resource)
    set_flash(resource)
    reload_lock_versions(resource)

    render :edit, status: :conflict
  end

  def set_flash(resource)
    flash.now[:alert] = t(
      'flash.actions.update.stale',
      resource_name: resource.class.model_name.human,
      stale_info:    t('flash.actions.update.stale_attributes_list',
        stale_attributes: stale_attributes_sentence(resource),
        count:            resource.stale_info.size
      )
    )
  end

  def reload_lock_versions(resource)
    # Set lock version to current value in DB so when saving again (after manually solving the conflicts), no StaleObjectError is thrown anymore
    resource.stale_info.each do |stale_info|
      stale_info.resource.lock_version = stale_info.resource.class.find(stale_info.resource.id).lock_version
    end
  end

  def stale_attributes_sentence(resource)
    resource.stale_info.map { |info| info.human_attribute_name }.to_sentence
  end
end
