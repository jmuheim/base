class AddTranslationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column    :users, :about_de, :text
    rename_column :users, :about, :about_en
  end
end
