module NavbarHelper
  def navbar(id, options = {}, &block)
    Navbar.new(id, self, options, block).render
  end
end

class Lego < Struct.new(:id, :view, :options, :block)
  delegate :link_to, to: :view

  def initialize(id = nil, view, options, block)
    self.id = "#{id}_#{name}"
    self.view = view
    self.options = options

    options.merge! defaults

    super
  end

  def name
    self.class.name.underscore
  end

  def render
    view.render "bootstrap/#{name}", { id:      id,
                                       content: view.capture(self, &block) # TODO: Would be nicer to use yield in view!
                                     }.merge(options)
  end

  def defaults
    {}
  end
end

class Navbar < Lego
  def defaults
    { home: nil,
      klass: ['navbar-dark', 'bg-dark', 'navbar-expand-md'],
      collapse_target: "#{id}_collapse"
    }
  end

  def home(&block)
    options[:home] = view.capture(self, &block)
  end

  def nav(id, options = {}, &block)
    Nav.new(id, view, options, block).render
  end

  class Nav < Lego
    def item(target, options = {}, &block)
      options[:target] = target

      Item.new(view, options, block).render
    end

    def dropdown(title, options = {}, &block)
      options[:title] = title

      Dropdown.new(title, view, options, block).render
    end

    class Item < Lego
      attr_accessor :target

      def defaults
        { target: options[:target] }
      end
    end

    class Dropdown < Lego
      attr_accessor :title

      def defaults
        { title: options[:title] }
      end

      def item(target, options = {}, &block)
        options[:target] = target

        Item.new(view, options, block).render
      end

      class Item < Lego # Duplicate? Smelly?
        attr_accessor :target

        def defaults
          { target: options[:target] }
        end
      end
    end
  end
end
