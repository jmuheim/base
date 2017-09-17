class CreatePageTitleAndNavigationTitleAndLeadAndContentTranslationsForMobilityColumnBackend < ActiveRecord::Migration[5.0]
  def change
    add_column    :pages, :title_de, :string
    rename_column :pages, :title, :title_en

    add_column    :pages, :navigation_title_de, :string
    rename_column :pages, :navigation_title, :navigation_title_en

    add_column    :pages, :lead_de, :text
    rename_column :pages, :lead, :lead_en

    add_column    :pages, :content_de, :text
    rename_column :pages, :content, :content_en
  end
end
