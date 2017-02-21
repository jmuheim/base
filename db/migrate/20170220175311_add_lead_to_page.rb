class AddLeadToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :lead, :text
  end
end
