class OrderPages < ActiveRecord::Migration[5.0]
  def change
    Page.all.each_with_index do |page, index|
      page.update_attribute :position, index + 1
    end
  end
end
