class CustomersController < ApplicationController
  load_and_authorize_resource
  before_action :add_breadcrumbs
  respond_to :html

  def create
    @customer.save
    respond_with @customer
  end

  def update
    @customer.update_attributes(customer_params)
    respond_with @customer
  end

  def destroy
    @customer.destroy
    respond_with @customer
  end

  private

  def customer_params
    params.require(:customer).permit(:name,
                                      :address,
                                      :description)
  end

  def add_breadcrumbs
    add_breadcrumb Customer.model_name.human(count: :other), customers_path

    add_breadcrumb @customer.name,    customer_path(@customer)      if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),  new_customer_path             if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'), edit_customer_path(@customer) if [:edit, :update].include?        action_name.to_sym
  end
end
