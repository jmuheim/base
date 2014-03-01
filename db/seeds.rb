josh = User.create! do |user|
         user.username     = 'josh'
         user.email        = 'josh@josh.ch'
         user.password     = 'joshjosh'
         user.confirmed_at = Time.now
       end

josh.add_role :admin

marc = User.create! do |user|
         user.username     = 'marc'
         user.email        = 'marc@marc.ch'
         user.password     = 'marcmarc'
         user.confirmed_at = Time.now
       end
