class SetCreatorAndUpdaterOfPages < ActiveRecord::Migration[5.0]
  def up
    user = User.first

    Page.all.each do |page|
      page.creator = user
      page.updater = user

      page.save!
    end
  end
end
