class CreateAppConfigs < ActiveRecord::Migration[5.2]
  def change
    # See https://stackoverflow.com/questions/399447/how-to-implement-a-singleton-model
    create_table :app_configs, id: false do |t|
      t.integer :id, null: false, primary_key: true, default: 1, index: {unique: true}
      t.string :app_abbreviation, default: 'Base'
      t.string :app_name, default: 'Base Project'
      t.string :app_slogan_de, default: 'Vorkonfiguriertes grundlegendes zugängliches Rails Projekt. Fork erstellen!'
      t.string :app_slogan_en, default: 'Pre-configured basic accessible Rails project. Fork me!'
      t.string :organisation_name_de, default: 'Josua Muheim'
      t.string :organisation_name_en, default: 'Josua Muheim'
      t.string :organisation_abbreviation_de, default: 'JM'
      t.string :organisation_abbreviation_en, default: 'JM'
      t.string :organisation_url, default: 'https://github.com/jmuheim/base'

      t.integer :lock_version, default: 0, null: false

      t.timestamps
    end
  end
end
