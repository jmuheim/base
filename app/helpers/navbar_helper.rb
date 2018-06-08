module NavbarHelper
  def navbar(id, options = {}, &block)
    options[:id] = id
    Navbar.new(self, options, block).render
  end
end

class Lego < Struct.new(:view, :options, :block)
  delegate :link_to, to: :view

  def initialize(view, options, block)
    self.view = view
    self.options = options

    self.options[:id] = name
    options.merge! defaults

    super
  end

  def name
    self.class.name.underscore
  end

  def path
    "bootstrap/#{name}"
  end

  def render
    view.render path, { content: view.capture(self, &block) # TODO: Would be nicer to use yield in view!
                      }.merge(options)
  end

  def defaults
    {}
  end

  def self.provides(*args)
    options = args.extract_options!
    legos = options

    args.each do |lego|
      legos[lego] = nil
    end

    legos.each_pair do |method, params|
      params = [params].flatten

      define_method method do |*args, &block|
        options = args.extract_options!

        raise "Param mismatch! Expected param names: #{params.join}; given params: #{args.join}." if args.size != params.size
        params.each_with_index do |param, i|
          options[param] = args[i]
        end

        name.classify.constantize.const_get(method.to_s.classify).new(view, options, block).render
      end
    end
  end
end

class Navbar < Lego
  provides nav: :id

  def defaults
    { home: nil,
      klass: ['navbar-dark', 'bg-dark', 'navbar-expand-md'],
      collapse_target: "#{options[:id]}_collapse"
    }
  end

  def home(&block)
    options[:home] = view.capture(self, &block)
  end

  class Nav < Lego
    provides mega: :title,
             item: :target,
             dropdown: :title

    class Mega < Lego
    end

    class Item < Lego
    end

    class Dropdown < Lego
      provides item: :target

      class Item < Lego
      end
    end
  end
end
