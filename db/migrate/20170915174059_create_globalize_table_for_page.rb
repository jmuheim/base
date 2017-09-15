class CreateGlobalizeTableForPage < ActiveRecord::Migration[5.0]
  def up
    Page.create_translation_table!({ title:            :string,
                                     navigation_title: :string,
                                     lead:             :text,
                                     content:          :text },
                                   { migrate_data: true })

    remove_column :pages, :title
    remove_column :pages, :navigation_title
    remove_column :pages, :lead
    remove_column :pages, :content
  end

  def down
    Page.drop_translation_table!
  end
end
