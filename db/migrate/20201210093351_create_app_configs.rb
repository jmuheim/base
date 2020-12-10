class CreateAppConfigs < ActiveRecord::Migration[5.2]
  def change
    # See https://stackoverflow.com/questions/399447/how-to-implement-a-singleton-model
    create_table :app_configs, id: false do |t|
      t.integer :id, null: false, primary_key: true, default: 1, index: {unique: true}
      t.string :app_abbreviation, null: false
      t.string :app_name, null: false
      t.string :app_slogan_de, null: false
      t.string :app_slogan_en, null: false
      t.string :organisation_name_de, null: false
      t.string :organisation_name_en, null: false
      t.string :organisation_abbreviation_de, null: false
      t.string :organisation_abbreviation_en, null: false
      t.string :organisation_url, null: false

      t.integer :lock_version, default: 0, null: false

      t.timestamps
    end
  end
end
