class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string  :name, null: false
      t.text    :description
      t.string  :customer

      t.timestamps
    end
  end
end
