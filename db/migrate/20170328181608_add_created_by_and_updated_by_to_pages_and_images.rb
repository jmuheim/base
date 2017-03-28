class AddCreatedByAndUpdatedByToPagesAndImages < ActiveRecord::Migration[5.0]
  def change
    [:pages, :images].each do |table|
      [:created_by_id, :updated_by_id].each do |column|
        add_column    table, column, :integer, default: User.first.id, null: false
        change_column table, column, :integer, default: nil

        add_foreign_key table, :users, column: column
      end
    end
  end
end
