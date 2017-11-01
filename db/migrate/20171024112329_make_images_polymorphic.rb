class MakeImagesPolymorphic < ActiveRecord::Migration[5.0]
  def change
    rename_column :images, :page_id, :imageable_id
    add_column :images, :imageable_type, :string, default: 'Page', null: false
    change_column_default :images, :imageable_type, nil

    add_index :images, [:imageable_type, :imageable_id]
  end
end