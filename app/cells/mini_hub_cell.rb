class MiniHubCell < Cell::Rails

  def show(args)
    @member = args[:member]
    render
  end

end
