admin = User.create! do |user|
         user.name             = 'admin'
         user.email            = 'admin@example.com'
         user.password         = 'adminadmin'
         user.confirmed_at     = Time.now
         user.role             = 'admin'
         user.bypass_humanizer = true
       end

editor = User.create! do |user|
          user.name             = 'editor'
          user.email            = 'editor@example.com'
          user.password         = 'editoreditor'
          user.confirmed_at     = Time.now
          user.bypass_humanizer = true
        end

user = User.create! do |user|
         user.name             = 'user'
         user.email            = 'user@example.com'
         user.password         = 'useruser'
         user.confirmed_at     = Time.now
         user.bypass_humanizer = true
       end
