class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :navigation_title
      t.text :content
      t.text :notes
      t.boolean :system, default: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
