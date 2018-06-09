module NavbarHelper
  def navbar(id, options = {}, &block)
    options[:id] = id
    Navbar.new(self, options, block).render
  end
end

class Lego < Struct.new(:view, :options, :block)
  def initialize(view, options, block)
    self.view = view
    self.options = options

    self.options[:id] ||= name.gsub '/', '_'
    options.reverse_merge! defaults

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

    legos.each_pair do |lego, params|
      params = [params].flatten.compact

      namespace = name.classify.constantize
      klass = namespace.const_set(lego.to_s.classify, Class.new(self))

      define_method lego do |*args, &block|
        options   = args.extract_options!

        raise "Param mismatch! Expected param names: #{params.join ', '}; given params: #{args.join ', '}." if args.size != params.size
        params.each_with_index do |param, i|
          options[param] = args[i]
        end

        klass.new(view, options, block).render
      end
    end
  end
end

class Navbar < Lego
  provides nav: :id

  def defaults
    { home: nil,
      klass: ['navbar-dark', 'bg-dark', 'navbar-expand-md'],
      collapse_target: "#{options[:id]}_collapse",
      active_class: view.current_page?(view.root_path) ? 'active' : nil,
    }
  end

  def home(&block)
    options[:home] = view.capture(self, &block)
  end

  class Nav
    provides mega: [:title, :target],
             item: :target,
             dropdown: [:title, :target]

    def defaults
      { klass: 'nil'
      }
    end

    class Item
      def defaults
        { active_class: view.has_breadcrumb?(options[:target]) ? 'active' : nil
        }
      end
    end

    class Mega
      def defaults
        { active_class: view.has_breadcrumb?(options[:target]) ? 'active' : nil
        }
      end
    end

    class Dropdown
      provides item: :target

      def defaults
        { active_class: view.has_breadcrumb?(options[:target]) ? 'active' : nil,
          klass: nil
        }
      end

      class Item
        def defaults
          { active_class: view.current_page?(options[:target]) ? 'active' : nil
          }
        end
      end
    end
  end
end
