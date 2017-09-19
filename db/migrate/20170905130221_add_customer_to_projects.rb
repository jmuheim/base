class AddCustomerToProjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :customer, foreign_key: true
  end
end
