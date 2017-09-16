class TranslatePages < ActiveRecord::Migration[5.0]
  def change
    rename_column :pages, :title, :title_en
    rename_column :pages, :navigation_title, :navigation_title_en
    rename_column :pages, :lead, :lead_en
    rename_column :pages, :content, :content_en

    add_column :pages, :title_de,            :string
    add_column :pages, :navigation_title_de, :string
    add_column :pages, :lead_de,             :string
    add_column :pages, :content_de,          :string
  end
end
