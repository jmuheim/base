module Base
  module Matchers
    class HaveBreadcrumbs
      def initialize(*breadcrumbs)
        @breadcrumbs = breadcrumbs
      end

      def matches?(controller)
        @breadcrumbs.each_with_index do |breadcrumb, index|
          index += 1
          a = ' a' unless index == @breadcrumbs.size

          selector = "#breadcrumbs li:nth-child(#{index})#{a}"
          unless controller.has_css? selector, text: breadcrumb
            @failure_index = index
            @failure_breadcrumb = breadcrumb
            @actual_text = controller.find(selector).text
            return false
          end
        end
      end

      def failure_message
        "expected that \"#{@failure_breadcrumb}\" would be at position #{@failure_index} of the breadcrumbs, but there was \"#{@actual_text}\""
      end
    end

    def have_breadcrumbs(*args)
      HaveBreadcrumbs.new(*args)
    end
  end
end