class AddNameToMembers < ActiveRecord::Migration
  def change
    add_column :members, :name, :string
    add_index :members, :name, unique: true
  end
end
