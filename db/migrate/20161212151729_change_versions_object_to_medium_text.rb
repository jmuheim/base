class ChangeVersionsObjectToMediumText < ActiveRecord::Migration
  def change
    # Needed because of this: http://stackoverflow.com/questions/41088654/papertrail-how-to-handle-data-too-long-for-column-object
    change_column :versions, :object, :text, limit: 16.megabytes - 1
  end
end
