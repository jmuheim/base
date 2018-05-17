module NavbarHelper
  def navbar(id, options = {}, &block)
    Navbar.new(id, options, self, block).render
  end

  class Navbar < Struct.new(:id, :options, :view, :callback)
    delegate :link_to, to: :view
    attr_accessor :navbar_options, :options

    def initialize(id, options, view, callback)
      self.options = options

      self.navbar_options = {
        container_tag: options[:container_tag] || 'div'
      }

      self.id = "#{id}_navbar"

      super
    end

    def render
      view.render 'bootstrap/navbar', id:   id,
                                         body: view.capture(self, &callback),
                                         container_tag: navbar_options[:container_tag]
    end

    def item(target, &block)
      Item.new(target, options[:item_options] || {}, view, block).render
    end

    class Item < Struct.new(:target, :options, :view, :callback)
      attr_accessor :title_content, :body_content, :item_options

      def initialize(target, options, view, block)
        self.target = target

        self.item_options = {
          title_tag:   options[:title_tag]   || 'h3',
          item_class: options[:item_class] || nil # e.g. bg-light
        }

        super
      end

      def render
        view.capture(self, &callback)
        view.render 'bootstrap/navbar/item', target: target,
                                                title:       title_content,
                                                 body:        body_content,
                                                 title_tag:   item_options[:title_tag],
                                                 item_class: item_options[:item_class]
      end
    end
  end
end
