class ImageUploader < AbstractUploader
  def filename
    "#{mounted_as}.jpg"
  end
end

class SaveImagesAsJpg < ActiveRecord::Migration[5.2]
  def save_as_jpg(model, attribute)
    model.find_by_sql("SELECT * FROM #{model.to_s.tableize} WHERE #{attribute} <> ''").each do |record|
      path = File.expand_path "public/uploads/#{record.model_name.to_s.underscore}/#{attribute}/#{record.id}"

      if File.exists? "#{path}/#{attribute}.png"
        puts "Converting #{path}/#{attribute}.png to jpg"
        record.send "#{attribute}=", File.open("#{path}/#{attribute}.png")
      else
        puts "Could not find #{path}/#{attribute}.png"
        record.send "remove_#{attribute}=", true
      end
      record.save!

      Dir["#{path}/*.png"].each do |file|
        File.delete file
      end
    end
  end

  def up
    save_as_jpg User, 'avatar'
  end
end
