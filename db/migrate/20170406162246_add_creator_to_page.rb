class AddCreatorToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :creator_id, :integer
  end
end
