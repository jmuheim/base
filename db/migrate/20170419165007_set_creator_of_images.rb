class SetCreatorOfImages < ActiveRecord::Migration[5.0]
  def up
    user = User.first

    Image.all.each do |image|
      image.creator = user
      image.save!
    end
  end
end
