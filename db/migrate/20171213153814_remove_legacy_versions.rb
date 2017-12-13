class RemoveLegacyVersions < ActiveRecord::Migration[5.1]
  def up
    ['Topic', 'Boilerplate'].each do |legacy_model|
      PaperTrail::Version.where(item_type: legacy_model).delete_all
    end
  end
end
