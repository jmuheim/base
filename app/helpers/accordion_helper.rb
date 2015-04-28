module AccordionHelper
  def accordion(id, options = {}, &block)
    Accordion.new(id, options, self, block).render
  end

  class Accordion < Struct.new(:id, :options, :view, :callback)
    class Item < Struct.new(:id, :parent_id, :options, :view, :callback)
      attr_accessor :heading_content, :body_content

      def initialize(id, parent_id, options, view, block)
        self.id        = id
        self.parent_id = parent_id
        super
      end

      def heading(&block)
        self.heading_content = view.capture(self, &block)
      end

      def body(&block)
        self.body_content = view.capture(self, &block)
      end

      def render
        view.capture(self, &callback)

        view.render 'bootstrap/accordion/item', id:        id,
                                                parent_id: parent_id,
                                                title:     heading_content,
                                                body:      body_content
      end
    end

    delegate :content_tag, :link_to, to: :view
    attr_accessor :accordion_options, :item_options, :item_counter

    def initialize(id, options, view, callback)
      item_options = options.delete(:item_options)

      self.accordion_options = {
        container_tag: :div
      }.merge(options)

      self.id           = "#{id}_accordion"
      self.item_counter = 0

      super
    end

    def render
      view.render 'bootstrap/accordion/container', id:   id,
                                                   body: view.capture(self, &callback)
    end

    def item(&block)
      self.item_counter += 1
      Item.new("#{id}_item_#{item_counter}", id, options, view, block).render
    end
  end
end
