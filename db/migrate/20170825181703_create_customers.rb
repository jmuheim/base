class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.text   :address
      t.text   :description

      t.timestamps
    end
  end
end
