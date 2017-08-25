class CreateCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :codes do |t|
      t.string :title, null: false
      t.string :identifier, null: false
      t.references :page, foreign_key: true
      t.text :html
      t.text :css
      t.text :js
      t.string :thumbnail_url, null: false
      t.integer :lock_version, default: 0
      t.references :creator # TODO: Add foreign key constraint! (foreign_key: {to_table: :users})

      t.timestamps
    end
  end
end
