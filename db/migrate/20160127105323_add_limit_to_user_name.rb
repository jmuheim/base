class AddLimitToUserName < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, limit: 100
  end
end
