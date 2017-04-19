class MakeCreatorAndUpdaterOfPagesNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :pages, :creator_id, :integer, null: false
    change_column :pages, :updater_id, :integer, null: false
  end
end
