class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string     :file
      t.references :page
      t.string     :identifier # Although the identifier always is an integer, it can't be type :number because it exceeds its max. limit (11)
      t.integer    :lock_version, default: 0

      t.timestamps null: false
    end
  end
end
