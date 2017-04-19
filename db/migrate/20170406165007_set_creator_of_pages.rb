class SetCreatorOfPages < ActiveRecord::Migration[5.0]
  def up
    user = User.first

    Page.all.each do |page|
      page.creator = user
      page.save!
    end
  end
end
