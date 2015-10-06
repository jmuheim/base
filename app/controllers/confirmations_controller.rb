class ConfirmationsController < Devise::ConfirmationsController
  before_filter :add_base_breadcrumbs

  def add_base_breadcrumbs
    if ['new', 'create'].include? action_name
      add_breadcrumb t('breadcrumbs.confirmations.new')
    end
  end
end
