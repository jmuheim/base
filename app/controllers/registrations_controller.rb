class RegistrationsController < Devise::RegistrationsController
  after_filter :merge_and_remove_guest, only: :create

  def merge_and_remove_guest
    if @user.valid?
      # Place any stuff here that you would like to move from the guest user to the registered user, e.g. comments, etc.
      # See http://stackoverflow.com/questions/10902497/activerecord-move-all-children-to-another-record

      guest_user.destroy # Be sure that no transferred data depends on the guest user!
    end
  end
end
