class AddCreatorToImage < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :creator_id, :integer
  end
end
