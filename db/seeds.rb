admin = User.create! do |user|
         user.name         = 'admin'
         user.email        = 'admin@example.com'
         user.password     = 'adminadmin'
         user.confirmed_at = Time.now
       end

admin.add_role :admin

user = User.create! do |user|
         user.name         = 'user'
         user.email        = 'user@example.com'
         user.password     = 'useruser'
         user.confirmed_at = Time.now
       end

Page.create! do |page|
  page.title            = 'About Base',
  page.navigation_title = 'About',
  page.lead             = 'This is the lead.',
  page.content          = 'This is the about page. Put markdown formatted content here.',
  page.notes            = 'These are notes. Only admins can see them.',
  page.system           = true
  page.creator          = admin
end
