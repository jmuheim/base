class MiniHubCell < Cell::Rails
  include Devise::Controllers::Helpers
  helper_method :current_member, :member_signed_in?

  def show(args)
    @member = args[:member]
    render
  end

end
