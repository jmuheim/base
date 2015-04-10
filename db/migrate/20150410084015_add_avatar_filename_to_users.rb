class AddAvatarFilenameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_filename, :string
  end
end
