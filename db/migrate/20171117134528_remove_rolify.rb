class RemoveRolify < ActiveRecord::Migration[5.0]
  def change
    drop_table :roles
    drop_table :users_roles
  end
end
