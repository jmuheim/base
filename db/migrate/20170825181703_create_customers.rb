class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :customer
      t.text   :address

      t.timestamps
    end
  end
end
