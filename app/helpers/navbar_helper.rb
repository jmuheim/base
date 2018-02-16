module NavbarHelper
  def navbar(id, options = {}, &block)
    Navbar.new(id, options, self, block).render
  end

  class Navbar < Struct.new(:id, :options, :view, :callback)
    delegate :link_to, to: :view
    attr_accessor :navbar_options, :card_counter, :options

    def initialize(id, options, view, callback)
      self.options = options

      self.navbar_options = {
        container_tag: options[:container_tag] || 'div'
      }

      self.id            = "#{id}_navbar"
      self.card_counter = 0

      super
    end

    def render
      view.render 'bootstrap/navbar', id:   id,
                                         body: view.capture(self, &callback),
                                         container_tag: navbar_options[:container_tag]
    end

    def card(&block)
      self.card_counter += 1
      Item.new("#{id}_card_#{card_counter}", id, options[:item_options] || {}, view, block).render
    end

    class Item < Struct.new(:id, :parent_id, :options, :view, :callback)
      attr_accessor :title_content, :body_content, :item_options

      def initialize(id, parent_id, options, view, block)
        self.item_options = {
          title_tag:   options[:title_tag]   || 'h3',
          card_class: options[:card_class] || nil # e.g. bg-light
        }

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
        view.render 'bootstrap/navbar/card', id:          id,
                                                 parent_id:   parent_id,
                                                 title:       title_content,
                                                 body:        body_content,
                                                 title_tag:   item_options[:title_tag],
                                                 card_class: item_options[:card_class]
      end
    end
  end
end
