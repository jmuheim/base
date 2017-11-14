class RecreateImageVersions < ActiveRecord::Migration[5.0]
  def change
    Image.all.each do |image|
      image.file.recreate_versions!
    end
  end
end