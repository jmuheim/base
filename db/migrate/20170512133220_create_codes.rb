class CreateCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :codes do |t|
      t.string :title
      t.string :identifier
      t.references :page, foreign_key: true
      t.text :html
      t.text :css
      t.text :js
      t.integer :lock_version
      t.references :creator # TODO: Add foreign key constraint! (foreign_key: {to_table: :users})

      t.timestamps
    end
  end
end