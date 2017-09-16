class TranslatePages < ActiveRecord::Migration[5.0]
  def change
    rename_column :pages, :title, :title_en
    add_column :pages, :title_de, :string
  end
end
