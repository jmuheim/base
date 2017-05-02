class MakeCreatorOfImagesNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :images, :creator_id, :integer, null: false
  end
end
