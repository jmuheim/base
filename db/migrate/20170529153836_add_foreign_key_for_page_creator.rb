class AddForeignKeyForPageCreator < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :pages, :users, column: :creator_id, name: :index_pages_on_creator_id
  end
end
