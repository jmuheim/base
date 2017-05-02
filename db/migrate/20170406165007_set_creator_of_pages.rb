class SetCreatorOfPages < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.record_timestamps = false

    user = User.first

    Page.all.each do |page|
      page.creator = user
      page.save!
    end

    PaperTrail::Version.where(item_type: 'Page').each do |version|
      version.whodunnit = user.id
      version.save!
    end

    ActiveRecord::Base.record_timestamps = true
  end
end
