class AddPositionToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :position, :integer, default: 1, null: false
  end
end
