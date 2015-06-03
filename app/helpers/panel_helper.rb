module PanelHelper
  def panel(options = {}, &block)
    Panel.new(self, block).render
  end

  class Panel < Struct.new(:view, :callback)
    attr_accessor :heading_content, :body_content

    def heading(&block)
      self.heading_content = view.capture(self, &block)
    end

    def body(&block)
      self.body_content = view.capture(self, &block)
    end

    def render
      view.capture(self, &callback)

      view.render 'bootstrap/panel', heading: heading_content,
                                     body:    body_content
    end
  end
end
