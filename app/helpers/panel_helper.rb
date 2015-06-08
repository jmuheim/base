module PanelHelper
  def panel(type = :default, &block)
    Panel.new(self, type, block).render
  end

  class Panel < Struct.new(:view, :type, :callback)
    attr_accessor :heading_options, :heading_content, :body_options, :body_content

    def heading(options = {}, &block)
      self.heading_options = options
      self.heading_content = view.capture(self, &block)
    end

    def body(options = {}, &block)
      self.body_options = options
      self.body_content = view.capture(self, &block)
    end

    def render
      view.capture(self, &callback)

      view.render 'bootstrap/panel', type:            type,
                                     heading_content: heading_content,
                                     heading_options: heading_options,
                                     body_content:    body_content,
                                     body_options:    body_options
    end
  end
end
