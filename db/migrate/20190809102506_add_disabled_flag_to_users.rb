class AddDisabledFlagToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :disabled, :boolean, default: false
  end
end
