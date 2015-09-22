module Base
  module Matchers
    class HaveNavigationItems
      def initialize(*items)
        @items = items
      end

      def matches?(controller)
        @items.each_with_index do |item, index|
          # Only the last items is set to .active by SimpleNavigation gem! We use a JavaScript hack to make the parent items .active, but as we don't want to set js: true here, we only test the last item.
          active = '.active' if index + 1 == @items.size # TODO: We can do this better!

          unless controller.has_css? "#navigation li#{active} a", text: item
            @failure_item = item
            return false
          end
        end
      end

      def failure_message
        "expected that \"#{@failure_item}\" would be a navigation item, but it wasn't"
      end
    end

    def have_navigation_items(*args)
      HaveNavigationItems.new(*args)
    end
  end
end