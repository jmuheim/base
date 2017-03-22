class AddParentIdToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :parent_id, :integer
  end
end
