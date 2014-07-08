class MiniHubCell < Cell::Rails
  helper ImageGalleryHelper

  def show(args)
    @user = args[:user]
    render
  end
end
