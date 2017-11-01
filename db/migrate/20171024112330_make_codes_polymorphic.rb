class MakeCodesPolymorphic < ActiveRecord::Migration[5.0]
  def change
    rename_column :codes, :page_id, :codeable_id
    add_column :codes, :codeable_type, :string, default: 'Page', null: false
    change_column_default :codes, :codeable_type, nil

    add_index :codes, [:codeable_type, :codeable_id]
  end
end