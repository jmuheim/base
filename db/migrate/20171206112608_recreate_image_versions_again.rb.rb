class RecreateImageVersionsAgain < ActiveRecord::Migration[5.0]
  def up
    Image.all.each do |image|
      puts image
      image.file.recreate_versions!
    end
  end
end