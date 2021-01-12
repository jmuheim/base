module DialogHelper
  def dialog(id, options = {}, &block)
    Dialog.new(id, options, self, block).render
  end

  def dialog_button(id, options = {}, &block)
    content = capture(self, &block)
    render 'bootstrap/dialog/button', id: id,
                                      css_class: options[:class],
                                      content: content
  end

  class Dialog < Struct.new(:id, :options, :view, :callback)
    attr_accessor :button_options, :header_content, :body_content, :options

    def initialize(id, options, view, callback)
      self.options = options

      super
    end

    def header(&block)
      self.header_content = view.capture(self, &block)
    end

    def body(&block)
      self.body_content = view.capture(self, &block)
    end

    def render
      view.capture(self, &callback)

      view.render 'bootstrap/dialog', id: id,
                                      header_tag:     "h#{options[:heading_level] || 2}",
                                      header_content: header_content,
                                      body_content:   body_content
    end
  end
end
