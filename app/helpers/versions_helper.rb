module VersionsHelper
  def versions_whodunnit(user_id)
    user = User.where(id: user_id).first

    user.present? ? link_to(user.name, user) : user_id
  end
end