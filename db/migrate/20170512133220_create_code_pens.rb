class CreateCodePens < ActiveRecord::Migration[5.0]
  def change
    create_table :code_pens do |t|
      t.string :title
      t.string :identifier
      t.text :description
      t.references :page, foreign_key: true
      t.text :html
      t.text :css
      t.text :js
      t.integer :lock_version
      t.references :creator, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
