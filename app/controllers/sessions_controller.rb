class SessionsController < Devise::SessionsController
  after_filter :remove_guest_user, only: :create,
                                   if:   :user_signed_in?
end
