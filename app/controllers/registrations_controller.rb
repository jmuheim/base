class RegistrationsController < Devise::RegistrationsController
  after_filter :consolidate_registered_user_with_guest, only: :create

  def consolidate_registered_user_with_guest
    # It would be nice if we didn't have to do so much magic. It would be better to convert the guest user directly into a registered one instead of creating a registered one beneath the guest and then consolidating the two. See http://stackoverflow.com/questions/22428680

    if @user.valid?
      @current_user.annex_and_destroy!(@user)
      sign_in @current_user
    end
  end
end
