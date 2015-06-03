module AccordionHelper
  def accordion(id, options = {}, &block)
    Accordion.new(id, options, self, block).render
  end

  class Accordion < Struct.new(:id, :options, :view, :callback)
    class Item < Struct.new(:id, :parent_id, :options, :view, :callback)
      attr_accessor :title_content, :body_content

      def initialize(id, parent_id, options, view, block)
        self.id        = id
        self.parent_id = parent_id
        super
      end

      def title(&block)
        self.title_content = view.capture(self, &block)
      end

      def body(&block)
        self.body_content = view.capture(self, &block)
      end

      def render
        view.capture(self, &callback)

        view.render 'bootstrap/accordion/panel', id:        id,
                                                 parent_id: parent_id,
                                                 title:     title_content,
                                                 body:      body_content
      end
    end

    delegate :link_to, to: :view
    attr_accessor :accordion_options, :panel_options, :panel_counter

    def initialize(id, options, view, callback)
      panel_options = options.delete(:panel_options)

      self.accordion_options = {
        container_tag: :div
      }.merge(options)

      self.id           = "#{id}_accordion"
      self.panel_counter = 0

      super
    end

    def render
      view.render 'bootstrap/accordion', id:   id,
                                         body: view.capture(self, &callback)
    end

    def panel(&block)
      self.panel_counter += 1
      Item.new("#{id}_panel_#{panel_counter}", id, options, view, block).render
    end
  end
end
