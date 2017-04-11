class AddCreatedByAndUpdatedByToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :created_by_id, :integer
    add_column :pages, :updated_by_id, :integer
  end
end
