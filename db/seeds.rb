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
