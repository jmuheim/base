class AddAboutPage < ActiveRecord::Migration[5.0]
  def up
    Page.create! title: 'About Base',
                 navigation_title: 'About',
                 content: 'This is the about page. Put markdown formatted content here.',
                 notes: 'These are notes. Only admins can see them.',
                 system: true
  end
end
