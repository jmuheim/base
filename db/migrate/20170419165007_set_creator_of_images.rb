class SetCreatorOfImages < ActiveRecord::Migration[5.0]
  def up
    user = User.first

    Image.all.each do |image|
      image.creator = user
      image.save!
    end

    PaperTrail::Version.where(item_type: 'Image').each do |version|
      version.whodunnit = user.id
      version.save!
    end
  end
end
