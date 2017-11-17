class AddRoleToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :string, default: :user
    # TODO: Set manually in the DB afterwards!
  end
end
