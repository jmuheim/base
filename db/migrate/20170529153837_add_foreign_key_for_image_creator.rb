class AddForeignKeyForImageCreator < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :images, :users, column: :creator_id, name: :index_images_on_creator_id
  end
end
