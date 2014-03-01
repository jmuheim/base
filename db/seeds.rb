josh = User.create! do |user|
         user.username     = 'josh'
         user.email        = 'josh@example.com'
         user.password     = 'joshjosh'
         user.confirmed_at = Time.now
       end

josh.add_role :admin

marc = User.create! do |user|
         user.username     = 'marc'
         user.email        = 'marc@example.com'
         user.password     = 'marcmarc'
         user.confirmed_at = Time.now
       end
