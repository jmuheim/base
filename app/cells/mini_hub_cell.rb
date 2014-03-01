class MiniHubCell < Cell::Rails
  def show(args)
    @user = args[:user]
    render
  end
end
