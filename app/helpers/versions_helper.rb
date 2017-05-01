module VersionsHelper
  def versions_whodunnit(user_id)
    user = User.where(user_id).first

    if user.nil?
      user_id
    else
      link_to user.name, user
    end
  end
end