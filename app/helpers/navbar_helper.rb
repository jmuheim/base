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

    prepare_defaults

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

  # Override in sub class if needed
  define_method :prepare_defaults { }
end

class Navbar < Lego
  def prepare_defaults
    self.options[:klass] ||= ['navbar-dark', 'bg-dark', 'navbar-expand-md']
  end

  def item(target, options = {}, &block)
    options[:target] = target

    Item.new(view, options, block).render
  end

  class Item < Lego
    attr_accessor :target

    def prepare_defaults
      self.target = options[:target]
    end
  end
end
