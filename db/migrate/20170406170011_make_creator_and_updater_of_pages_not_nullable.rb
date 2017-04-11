class MakeCreatorAndUpdaterOfPagesNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :pages, :created_by_id, :integer, null: false
    change_column :pages, :updated_by_id, :integer, null: false
  end
end
