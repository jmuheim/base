# This is not intended to be used for negative expectations!
module Base
  module Matchers
    class HaveActiveNavigationItems
      def initialize(*items)
        @items = items
      end

      def matches?(controller)
        active_list_items = []

        @items.each_with_index do |item, index|
          active_list_items << "li.active"

          unless controller.has_css? "#navigation #{active_list_items.join ' > ul > '} a", text: item, visible: false
            @failure_item = item
            return false
          end
        end
      end

      def failure_message
        "expected that \"#{@failure_item}\" would be an active navigation item, but it wasn't"
      end
    end

    def have_active_navigation_items(*args)
      HaveActiveNavigationItems.new(*args)
    end
  end
end
