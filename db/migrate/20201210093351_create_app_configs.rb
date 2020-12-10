class CreateAppConfigs < ActiveRecord::Migration[5.2]
  def change
    # See https://stackoverflow.com/questions/399447/how-to-implement-a-singleton-model
    create_table :app_configs, id: false do |t|
      t.integer :id, null: false, primary_key: true, default: 1, index: {unique: true}
      t.string :app_abbreviation, null: false
      t.string :app_name
      t.string :app_slogan_de
      t.string :app_slogan_en
      t.string :organisation_name_de
      t.string :organisation_name_en
      t.string :organisation_abbreviation_de
      t.string :organisation_abbreviation_en
      t.string :organisation_url

      t.integer :lock_version, default: 0, null: false

      t.timestamps
    end
  end
end
