class RemoveAssociationsVersionsTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :version_associations
  end
end
